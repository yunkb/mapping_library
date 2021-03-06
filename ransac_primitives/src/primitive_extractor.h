#ifndef PRIMITIVE_EXTRACTOR_H
#define PRIMITIVE_EXTRACTOR_H

#include <pcl/point_cloud.h>
#include <pcl/octree/octree_impl.h>
#include <Eigen/Dense>
#include "primitive_params.h"
#include "primitive_octree.h"
#include "base_primitive.h"
#include "primitive_visualizer.h"

class primitive_extractor {
public:
    typedef pcl::PointXYZRGB point;
private:
    pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud; // pcl formats
    pcl::PointCloud<pcl::Normal>::Ptr cloud_normals;
    Eigen::MatrixXd mpoints; // points of cloud
    Eigen::MatrixXd mnormals; // normals of point cloud
    primitive_octree octree; // octree used for the entire cloud
    int tree_depth; // the levels of the octree
    Eigen::ArrayXi level_scores; // the sum of the number of primitives at each level of the octree
    //Eigen::VectorXd level_pdf;
    std::vector<base_primitive*> candidates; // candidates for new primitives
    int number_extracted; // number of primitives extracted, used for colors
    std::vector<primitive_octree> octrees; // the disjoint subsets as octrees
    std::vector<Eigen::MatrixXd, Eigen::aligned_allocator<Eigen::MatrixXd> > disjoint_points;
    std::vector<Eigen::MatrixXd, Eigen::aligned_allocator<Eigen::MatrixXd> > disjoint_normals;
    std::vector<int> total_set_size;

    std::vector<base_primitive*>& primitives; // primitive types used

    primitive_params params;
    //double inlier_threshold; // distance from shape that counts as inlier
    //double angle_threshold; // highest allowed normal angle deviation
    //double add_threshold; // probability required to add shape, P(|m| | |C|) < add_threshold
    //int least_support; // stop when we're confident enough not to have overlooked a shape with least_support points
    //double normal_radius; // radius within which we'll estimate the normals of a point

    primitive_visualizer* vis;

    void remove_distant_points(pcl::PointCloud<pcl::PointXYZRGB>::Ptr new_cloud, double dist);
    void estimate_normals();
    int sample_level(int iteration);
    void get_points_at_level(std::vector<int>& inds, point& p, int level);
    double prob_candidate_not_found(double candidate_size,
                                    double candidates_evaluated,
                                    int points_required);
    void remove_points_from_cloud(base_primitive* p);
    void add_new_primitive(base_primitive* primitive);
    void clear_primitives(std::vector<base_primitive *>& ps);
    void construct_octrees();
    base_primitive* max_inliers(double& maxmean, double& maxa, double& maxb,
                                std::vector<base_primitive*>& primitives);
    void overlapping_estimates(std::vector<base_primitive*>& primitives, base_primitive* best_candidate);
    double refine_inliers(std::vector<base_primitive *>& primitives);
public:
    void primitive_inlier_points(Eigen::MatrixXd& points, base_primitive* p);
    void extract(std::vector<base_primitive*>& extracted);
    pcl::PointCloud<pcl::Normal>::ConstPtr get_normals();
    pcl::PointCloud<pcl::PointXYZRGB>::ConstPtr get_cloud();
    primitive_extractor(pcl::PointCloud<pcl::PointXYZRGB>::Ptr cloud,
                        std::vector<base_primitive*>& primitives,
                        primitive_params params = primitive_params(),
                        primitive_visualizer* vis = NULL);
};

#endif // PRIMITIVE_EXTRACTOR_H

%% Show the histogram of the plane-plane edges

A = [];

m = length(G);
for i = 1:m
    if G{i}.edgeangles
        A = [A; G{i}.edgeangles];
    end
end

hist(A, 100);

%% Check that the correct indices are found

for i = 1:n
    [nodes, found] = size(node_indices{i});
    for j = 1:found
        for k = 1:nodes
            l1 = subg{i}.nodelabels(k);
            l2 = G{indices{i}(j)}.nodelabels(node_indices{i}(k, j));
            if l1 ~= l2
                l1
                l2
            end
        end
    end
end

%% Show an eigen analysis of the clustering problem

for i = 1:n
    vim = mean(V{i}, 2);
    vi = V{i} - vim*ones(1, size(V{i}, 2));
    [U, S, VV] = svd(vi');
    vi = VV'*vi;
    plot3(vi(1,:), vi(2,:), vi(3,:), '*')
    pause
end

%% Show distribution of plane and cylinder sizes

m = length(G);

planesizes = [];
cylindersizes = [];

p = primitives;
pind = cellfind(p, 'Plane');
cind = cellfind(p, 'Cylinder');

for i = 1:m
    ll = G{i}.nodelabels;
    for j = 1:length(ll)
       if ll(j) == pind
           planesizes = [planesizes G{i}.nodesizes(j)];
       elseif ll(j) == cind
           cylindersizes = [cylindersizes G{i}.nodesizes(j)];
       end
    end
end

hist(planesizes, 30)
figure
hist(cylindersizes, 30)

%% Convert the positions to the map coordinate system

P = positions(:, 1:2)';
P(2, :) = -P(2, :);
minp = min(P, [], 2);
maxp = max(P, [], 2);

[m, n] = size(map);
dist = maxp - minp;

l = length(P);
P = P - minp*ones(1, l);
P = P.*(([n; m]./dist)*ones(1, l));

% this is just a heuristic to find a transformation that looks good
P = (P + [110; -100]*ones(1, l)).*([0.75; 0.47]*ones(1, l))  + [7; 140]*ones(1, l);

imshow(map)
hold on
plot(P(1, :), P(2, :), '*r', 'MarkerSize', 2)
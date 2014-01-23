function show_positions_in_map(map, inds, indices, positions)

tangle = -12;
scaling = 20;
horizon = 2;

map = map(1575:2309, 1634:2553);
map = imrotate(map, tangle);
map = map(312:583, 115:946);
midx = 311;
midy = 187;

tangle = pi/180*tangle;
R = [cos(tangle) -sin(tangle); sin(tangle) cos(tangle)];

figure
imshow(map);
hold on

for i = inds
    P = positions(indices{i}, 1:2)';
    P(2, :) = -P(2, :);
    P = R'*P;
    l = length(P);

    angles = positions(indices{i}, 3)';
    offset = [cos(angles - tangle); sin(angles - tangle)];
    P = P + horizon*offset;

    % this is just a heuristic to find a transformation that looks good
    P = scaling*P + [midx; midy]*ones(1, l);

    Q = positions(indices{i}, 1:2)';
    Q(2, :) = -Q(2, :);
    Q = R'*Q;

    % this is just a heuristic to find a transformation that looks good
    Q = scaling*Q + [midx; midy]*ones(1, l);

    %angle = atan(); % offset through focal length
    len = scaling*horizon*326/566;

    x = zeros(1, 3);
    y = zeros(1, 3);
    for j = 1:l
        o = P(:, j) - Q(:, j);
        o = [o(2); -o(1)];
        o = len/norm(o)*o;
        x(1) = Q(1, j);
        y(1) = Q(2, j);
        x(2) = P(1, j) + o(1);
        y(2) = P(2, j) + o(2);
        x(3) = P(1, j) - o(1);
        y(3) = P(2, j) - o(2);
        fill(x, y, 'r', 'FaceAlpha', 0.15, 'EdgeAlpha', 0)
    end

    plot(Q(1, :), Q(2, :), 'o', 'MarkerSize', 4, 'MarkerFaceColor', 'b')
end

end
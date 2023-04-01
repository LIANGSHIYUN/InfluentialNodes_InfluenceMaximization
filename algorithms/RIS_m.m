function sorted_ix = RIS_m(data,drivernumber)
a = sum(data, 2);
source = [];
target = [];
n = size(data, 2);
for i = 1:n
    cols = data(:, i);
    index = find(cols ~= 0);
    source = [source, repmat(i, 1, length(index))];
    target = [target, index'];
end
G = table(source', target', 'VariableNames', {'source', 'target'});
k = drivernumber;
ris_output = RIS(G, a, k, 0.01, 50000);
[~, IX] = sort(hist(ris_output, unique(ris_output)), 'descend');
sorted_ix = unique(ris_output);
sorted_ix = sorted_ix(IX);
end

function [SEED, timelapse] = RIS(G, a, k, p, mc)
    start_time = tic;
    R = cell(1, mc);
    for i = 1:mc
        source = randsample(unique(G.source), 1);
        prob = 1/a(source);
        g = G(arrayfun(@(x) rand < prob, 1:size(G, 1)), :);
        new_nodes = source;
        RRS0 = source;
        while ~isempty(new_nodes)
            temp = g(ismember(g.target, new_nodes), 'source');
            temp = table2array(temp);
            temp = temp';
            RRS = unique([RRS0, temp]);
            new_nodes = setdiff(RRS, RRS0);
            RRS0 = RRS;
            %disp(RRS);
        end

        R{i} = RRS;
    end
    
    SEED = zeros(k, 1);
    timelapse = zeros(k, 1);
    for i = 1:k
        flat_map = cell2mat(R);
        seed = mode(flat_map);
        fprintf('(%d,%d)\n', seed, sum(flat_map == seed));
        SEED(i) = seed;
        for j = 1:mc
            if ismember(seed, R{j})
                R{j}(R{j} == seed) = [];
            end
        end
        timelapse(i) = toc(start_time);
    end
    SEED = sort(SEED);
end
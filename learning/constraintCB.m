function Yhat = constraintCB(params, model, X, YZ)
%CONSTRAINCB Summary of this function goes here
%  compute the augmented inference problem
%  Yhat = argmax_y(delta(y,yhat),psi(x,y;w))
%  psi(x,y;w) is a graph model, and each y node in the graph is connected
%  with a delta
%  the argmax is computed by MAP inference using libDAI

assert(length(model.w) == params.dimension)
assert(iscolumn(X))

K = length(X) / params.DimX; % length of sequence 

% build graphical model
factors = build_graphical_factors(X,params,model,[]);

% add loss factors
loss_factors = repmat(struct('var', [], 'card', [], 'val', []), K, 1);
for k = 1 : K
    loss_factors(k) = compute_loss_factor(params, YZ, k);
end

% combine all factors
all_factors = [factors;loss_factors];

% argmax_y delta(yi, y) + <psi(x,y), w>
Yhat = RunInference(all_factors);

end
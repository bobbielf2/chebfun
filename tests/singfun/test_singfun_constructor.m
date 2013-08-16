% Test file for SINGFUN constructor.

function pass = test_singfun_constructor(pref)

% Get preferences:
if ( nargin < 1 )
    pref = singfun.pref.singfun;
end
% Set the tolerance:
tol = 1e3*pref.eps;

pass = zeros(1, 4); % Pre-allocate pass matrix

%%
% Test calling syntax
a = 1;
b = .5;
fh = @(x) sin(x)./((1+x).^a.*(1-x).^b);
f = singfun(fh, [-a, -b]);
g = singfun(fh, [-a, -b], {'pole', 'sing'});
pass(1) = isequal(f,g);

%%
% Select some random points as sample points
% These random points are in [-.999, .999]
seedRNG(777)
%x = -.999 + 1.998*rand(1, 100);
x = -1 + 2*rand(1, 100);

fh = @(x) sin(x)./((1-x).*(1+x));
f = singfun(fh, [], {'pole', 'pole'});
pass(2) = norm(feval(f, x) - feval(fh, x), inf) < tol
norm(feval(f, x) - feval(fh, x), inf)

%%
%
fh = @(x) sin(exp(cos(10*pi*x)))./((1+x).^a.*(1-x).^b);
f = singfun(fh, [-a, -b]);
pass(3) = norm(feval(f, x) - feval(fh, x), inf) < tol
norm(feval(f, x) - feval(fh, x), inf)

%%
clear classes
%%
a = .5; b = 1.5;
op = @(x) sin(1-x)./((1-x).^(b).*(1+x).^(a));
exponents = [-a, -b];
exponents = [];
singType = {'sing', 'sing'};
pref = [];
f = singfun( op, exponents, singType, pref )

%%
imagf = imag(f)

%% 
realf = real(f)

%%
% works
f = singfun( @(x) sin(pi*(x+1))./((1-x).^3.5.*(x+1).^2.5), [], {'sing', 'sing'}, []  )
f = chebfun( @(x) sin(pi*(x+1))./((1-x).^3.5.*(x+1).^2.5), 'blowup', 1 )
%%
% doesn't work
f = singfun( @(x) sin(pi*(x+1))./((1-x).^3.*(x+1).^2), [], {'sing', 'sing'}, []  )
f = chebfun( @(x) sin(pi*(x+1))./((1-x).^3.5.*(x+1).^2.5), 'blowup', 2 )
%%
f = singfun( @(x) 1./(1-x).^2, [], {'pole', 'sing'} )

%%
f = singfun( @(x) sin(x)./((1-x).^3.5.*(1+x).^.5), [], {'sing', 'sing'}, [] );
g = singfun( @(x) cos(x)./(1-x), [], {'sing', 'sing'}, [] );
s = f + g
xx = -.9:.01:.9;
error = feval(s, xx) - (feval(f, xx)+ feval( g, xx));
norm(error, inf )
%plot(xx, error)

%%
f = singfun(@(x) 1./(1-x), [], {'sing', 'sing'})
fp = diff(f);
xx = -.99:.01:.99;
error = feval(fp, xx) - 1./(1-xx).^2;
norm(error, inf )
%plot(xx, error)

%%
a = pi;
f = singfun(@(x) sin(a*x)./(1-x).^2, [], [], [] );
fp = diff(f);
xx = -.99:.01:.99;
fpExact = @(x) a*cos(a*x)./(1-x).^2 + 2*sin(a*x)./(1-x).^3;
error = feval(fp, xx) - fpExact(xx);
norm(error, inf )
%plot(xx, error)
%%
% works but if we change f to -f, it doesn't
f = chebfun( @(x) sin(12*pi*(1-x))./(1-x).^2, 'blowup', 'on' )
%plot(f) % the plot is wrong?
[a, b] = min(f)
%%
f = singfun( @(x) sin(12*pi*(1-x))./(1-x).^2 )
[a, b ] = minandmax(f)
%%
% f changed to -f doesn't work
%f = chebfun( @(x) -sin(1-x)./(1-x).^2, 'blowup', 'on' )
%a = min(f)

%%
f = chebfun(@(x) cos(pi/2*x)./(1-x).^2, 'blowup', 'on' )
g = 1./f
xx = -.99:.01:.99;
norm( feval(g,xx) - (1-xx).^2./cos(pi*xx/2), inf )

%%
gsmoothVals = g.funs.vals;
gsmooth = chebfun( gsmoothVals )
gsmooth = gsmooth
%%
f = singfun( @(x) cos(pi*x/2)./(1-x).^2)
g = 1./f
xx = -.99:.01:.99;
norm( feval(g,xx) - (1-xx).^2./cos(pi*xx/2), inf )
%%
gg = singfun(@(x) (1-x).^2./cos(pi*x/2) )
norm( feval(g,xx) - feval(gg,xx), inf )
%% 
f = singfun( @(x) (1-x).^.5.*(1+x).^.5, [.5, .5] )
g = 1./f
xx = -.99:.01:.99;
norm( feval(g,xx) - (1-xx).^-.5.*(1+xx).^-.5, inf )

%% 
f = chebfun(@(x) (1-x).^.5.*(1+x).^.5, 'splitting', 'on')
g = 1./f

%%
 b = -1; a = -1;
 f = singfun( @(x) (1-x).^b.*(1+x).^a, [], {'pole', 'pole'})
 g = 1./f
 %%
 f = 1./g 
 %g = 1./f
 
%%
f = singfun( @(x) (1-x).^.5.*(1+x).^.5, [.5 .5] )

%%
f = chebfun(@(x) sqrt(1+x), 'blowup', 2 )

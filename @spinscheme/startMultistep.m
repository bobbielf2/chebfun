function [uSol, NuSol, dt] = startMultistep(K, adaptiveTime, dt, L, LR, Nc, ...
    Nv, pref, S, uSol, NuSol)
%STARTMULTISTEP  Get enough initial data when using a multistep scheme.
%    [USOL, NUSOL, DT] = STARTMULTISTEP(K, ADAPTIVETIME, DT, L, LR, NC, NV, ...
%    PREF, S, USOL, NUSOL) does a few steps of a one-step scheme with timestep 
%    DT to get enough initial data start the multistep SPINSCHEME K, using the 
%    linear part L, the linear part for complex means LR, the nonlinear parts of 
%    the operator in coefficient and value space NC and NV, the SPINPREFERENCE 
%    object PREF, and the SPINOPERATOR S. ADAPTIME is 1 if adpative in time, 
%    0 otherwise.

% Copyright 2016 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Set-up:
errTol = pref.errTol;       % error tolerance 
M = pref.M;                 % points for the contour integral
q = K.steps;                % number of steps 
nVars = S.numVars;          % number of unknown functions
N = size(uSol{1}, 1)/nVars; % number of grid points

% Create a cell-array to store the coefficients at the Q steps:
coeffs = cell(q, 1);
Ncoeffs = cell(q, 1);

% Store the initial conidition in the last column:
coeffs{q} = uSol{1};
Ncoeffs{q} = NuSol{1};

% Set-up ETDRK4:
K = spinscheme('etdrk4');
schemeCoeffs = computeCoeffs(K, dt, L, LR, S);
if ( adaptiveTime == 1 )
    LR2 = computeLR(S, dt/2, L, M, N);
    schemeCoeffs2 = computeCoeffs(K, dt/2, L, LR2, S);
end

% Do Q-1 steps of EXPRK5S8:
iter = 1;
while ( iter <= q-1 ) 
    
    [cNew, NcNew] = oneStep(K, schemeCoeffs, Nc, Nv, nVars, uSol, NuSol);
     
    % If adpative in time, two steps in time with DT/2 and N points:
    if ( adaptiveTime == 1 )
        [cNew2, NcNew2] = oneStep(K, schemeCoeffs2, Nc, Nv, nVars, uSol, NuSol);
        [cNew2, NcNew2] = oneStep(K, schemeCoeffs2, Nc, Nv, nVars, cNew2, ...
            NcNew2);
        err = max(max(max(abs(cNew{1} - cNew2{1}))));
        % If successive step, store it:
        if ( err < errTol ) 
            coeffs{q-iter} = cNew2{1};
            Ncoeffs{q-iter} = NcNew2{1};
            uSol = cNew2;
            iter = iter + 1;
        % Otherwise, redo the step with DT/2 and N points:
        else
            dt = dt/2;
            schemeCoeffs = schemeCoeffs2;
            LR2 = computeLR(S, dt/2, L, M, N);
            schemeCoeffs2 = computeCoeffs(K, dt/2, L, LR2, S);
        end
        
    % If not adaptive in time, keep CNEW:
    else
        coeffs{q-iter} = cNew{1};
        Ncoeffs{q-iter} = NcNew{1};
        uSol = cNew;
        NuSol = NcNew;
        iter = iter + 1;
    end

end
uSol = coeffs;
NuSol = Ncoeffs;

end
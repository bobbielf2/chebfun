function display(X)
%DISPLAY   Display information about a CHEBFUN3.
%   DISPLAY(F) outputs important information about the CHEBFUN3 F to the command
%   window, including its domain of definition, multilinear rank used to
%   represent it), and a summary of its structure.
%
%   It is called automatically when the semicolon is not used at the end of a
%   statement that results in a CHEBFUN3.
%
% See also DISP.

if ( isequal(get(0, 'FormatSpacing'), 'compact') )
	disp([inputname(1), ' =']);
	disp(X);
else
	disp(' ');
	disp([inputname(1), ' =']);
	disp(' ');
    disp(X);
end

end
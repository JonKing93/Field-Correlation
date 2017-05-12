function[i1, i2] = assignLagIndices(dates1, dates2, interval)
%% Assigns time indices for lagFieldcorr to two sets of overlapping, 
% equally spaced datetime vectors. The first overlapping date will be given
% an index of 0.
%
% [i1, i2] = assignLagIndices(dates1, dates2)
% Assigns indices to two datetime vectors for use in lagFieldcorr.
%
%
% ----- Inputs -----
%
% dates1: A datetime vector. Must be equally spaced.
%
% dates2: A datetime vector. Must be equally spaced at the same interval as
%       dates1 and also overlap dates1.
%
% interval: A flag for the spacing interval
%   'annual': Constant annual spacing
%   'monthly': Constant monthly spacing
%   'daily': Constant daily spacing, years contain leap days
%   'exact': Spacing interval is constant to the second
%
%
% ----- Outputs -----
%
% i1: The lag indices for the first set of dates.
%
% i2: The lag indices for the second set of dates.
%
%
% ----- Written By -----
%
% Jonathan King, 2017, University of Arizona, jonking93@email.arizona.edu

% Initial error checking
if ~isvector(dates1) || ~isvector(dates2) || ~isdatetime(dates1) || ~isdatetime(dates2)
    error('dates1 and dates2 must be datetime vectors');
end

% Ensure that some dates overlap 
[overlap,~,~] = intersect( dates1, dates2);
if isempty(overlap)
    error('There are no overlapping dates');
end

% Convert to datevector for annual or monthly spacing
if strcmpi(interval, 'annual') || strcmpi(interval, 'monthly')
    d1 = datevec(dates1);
    d2 = datevec(dates2);
end

% Ensure that dates1 and dates2 have the proper spacing
if strcmpi(interval, 'annual')   
    d1space = d1(2:end,1) - d1(1:end-1,1);
    d2space = d2(2:end,1) - d2(1:end-1,1);
elseif strcmpi(interval, 'monthly')
    d1 = d1(:,1)*12 + d1(:,2);
    d2 = d2(:,1)*12 + d2(:,2);
    
    d1space = d1(2:end) - d1(1:end-1);
    d2space = d2(2:end) - d2(1:end-1);
elseif strcmpi(interval, 'daily')
    d1space = days( dates1(2:end) - dates1(1:end-1) );
    d2space = days( dates1(2:end) - dates1(1:end-1) );
elseif strcmpi(interval, 'exact')
    d1space = dates1(2:end) - dates1(1:end-1);
    d2space = dates2(2:end) - dates2(1:end-1);    
else
    error('Unrecognized interval');
end
    
% Ensure spacing is constant
if any(d1space~=d1space(1))
    error('spacing in dates1 is not constant');
elseif any(d2space~=d2space(1))
    error('spacing in dates2 is not constant');
end

% Ensure the spacings are equal
if d1space(1) ~= d2space(1)
    error('dates1 and dates2 must have equal spacing');
end
    
% Assign the indices
if any( dates2 == dates1(1) ) 
    % First overlap is zero, and occurs at beginning of dates1
    i1 = ( 0:length(dates1)-1 )';
    
    % Get the index of overlap for dates2
    dex = find(dates2 == dates1(1));
    
    % Get the indices for dates2
    i2 = (  -(dex-1):length(dates2)-dex  )';    
else
    % First overlap is at beginning of dates2
    i2 = ( 0:length(dates2)-1 )';
    
    % Get the index of overlap for dates2
    dex = find(dates1 == dates2(1));
    
    % Get the indices for dates1
    i1 = (  -(dex-1):length(dates1)-dex  )';
end
end
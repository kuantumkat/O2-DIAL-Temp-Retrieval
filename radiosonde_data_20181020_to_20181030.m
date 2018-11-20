filename = 'raob_soundings24581.cdf';

% Open netcdf file
ncid = netcdf.open(filename);

% Read the number of dimensions and number of variables in the file
[numdims, numvars, numglobalatts, unlimdimID] = netcdf.inq(ncid);

% Read in information about each dimension
dim_names = {};
dim_sz = [];
data = [];
for i = 0:numdims-1

    [dimname, dimlen] = netcdf.inqDim(ncid,i);
    dim_names{i+1} = dimname;
    dim_sz = [dim_sz, dimlen];
    
end

% Read variables
var_names = {};
var_types = [];
var_dims = {};
var_natts = [];
var_data = {};
for i =0:numvars-1
   
    % Inquire about variables
    [varname,xtype,dimids,natts] = netcdf.inqVar(ncid,i);  
    var_names{i+1} = varname;
    var_types = [var_types, xtype];
    var_dims{i+1} = dimids;
    var_natts = [var_natts, natts];
    
    % Read in data
    count = dim_sz(dimids+1);
    start = 0 * count;
    data = netcdf.getVar(ncid,i,start,count);
    var_data{i+1} = data;
        
end
    
time_name = 'synTime';
time_index = find(strcmp(var_names,time_name));
time_data = var_data{time_index};
time_dims = var_dims{time_index};

time_data = datetime(time_data,'convertfrom','posixtime');  % Convert from unix time to normal time/date

pressure_name = 'prMan';
pressure_index = find(strcmp(var_names,pressure_name));
pressure_data = var_data{pressure_index};
pressure_dims = var_dims{pressure_index};

pressure_data(pressure_data == max(max(pressure_data))) = NaN;

height_name = 'htMan';
height_index = find(strcmp(var_names,height_name));
height_data = var_data{height_index};
height_dims = var_dims{height_index};

height_data(height_data == max(max(height_data))) = NaN;
height_data(1,:) = 0;   % Change first row from Denver elevation to 0 (surface)

temp_name = 'tpSigT';
temp_index = find(strcmp(var_names,temp_name));
temp_data = var_data{temp_index};
temp_dims = var_dims{temp_index};

temp_data(temp_data == max(max(temp_data))) = NaN;
temp_data(temp_data == max(max(temp_data))) = NaN;

%plot(temp_data(1:5,12),height_data(1:5,12))
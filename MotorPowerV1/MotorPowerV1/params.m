[time, speed] = readvars("Track Drivecycles.xlsx", "Range", "B4:C1013");
velocity = speed(:);
timing = time(:);
vtmatrix = [timing(:), velocity(:)];
v = [];
%%parameters
totalMass = 310.5; %%total mass = vehicle mass + driver mass = 310.5 kg | from parameters.m
t_step = 0.1; %%[s]
rollingResCoeff = 0.02; %%[unitless]
g = 9.81; %%[m/s^2]
radius = 0.65/2; %%[m]
airDensity = 1.293; %%[kg/m^3]
CdA = 0.3976; %%[m^2]

for i=2: length(speed)
    v(i) = speed(i)-speed(i-1);
end

delv = v(:);
delvmatrix = [timing(:), delv(:)];
a = delv/t_step;
amatrix = [timing(:), a(:)];

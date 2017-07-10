function time = stokes(h,den_clay)

r = 1*10^-6;
den_fluid =1;
g = 9.81;
viscosity = 0.001025;


time = h/[[[2*r^2]*(den_clay-den_fluid)*g*10^3]/[9*viscosity]];
time = time/3600;

end

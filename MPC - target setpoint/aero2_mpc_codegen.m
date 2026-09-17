%% Generate CasADi function for Simulink
F = solver.to_function('mpc_solver', ...
    {xinit, xref}, {u(:,1)}, ...
    {'x0','xref'}, {'u_opt'});

cg_options = struct;
cg_options.casadi_real = 'real_T';
cg_options.casadi_int  = 'int_T';
cg_options.real_min    = num2str(realmin('double'));
cg_options.with_header = true;
cg = casadi.CodeGenerator('mpc_solver', cg_options);
cg.add_include('simstruc.h');
cg.add(F);
cg.generate();
fprintf('C code generated \n');

%% Compile MEX file
fprintf('\nCOMPILING S-FUNCTION\n');
mex('mpc_solver_wrapper.c', 'mpc_solver.c');
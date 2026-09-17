#define S_FUNCTION_NAME  mpc_solver_wrapper
#define S_FUNCTION_LEVEL 2

#include "simstruc.h"
#include "mpc_solver.h"

#define P(msg) ssPrintf("[mpc] %s\n", msg)


static void mdlInitializeSizes(SimStruct *S)
{
    P("InitSizes...");

    ssSetNumSFcnParams(S, 0);
    if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
        return; /* Parameter mismatch will be reported by Simulink */
    }

    /* Read in CasADi function dimensions */
    int_T n_in  = mpc_solver_n_in();
    int_T n_out = mpc_solver_n_out();
    int_T sz_arg, sz_res, sz_iw, sz_w;
    mpc_solver_work(&sz_arg, &sz_res, &sz_iw, &sz_w);
    
    /* Set up simulink input/output ports */
    int_T i;
    if (!ssSetNumInputPorts(S, n_in)) return;
    for (i=0;i<n_in;++i) {
      const int_T* sp = mpc_solver_sparsity_in(i);
      /* Dense inputs assumed here */
      ssSetInputPortDirectFeedThrough(S, i, 1);
      ssSetInputPortMatrixDimensions(S, i, sp[0], sp[1]);
      ssSetInputPortRequiredContiguous(S, i, 1);
    }

    if (!ssSetNumOutputPorts(S, n_out)) return;
    for (i=0;i<n_out;++i) {
      const int_T* sp = mpc_solver_sparsity_out(i);
      /* Dense outputs assumed here */
      ssSetOutputPortMatrixDimensions(S, i, sp[0], sp[1]);
    }

    ssSetNumSampleTimes(S, 1);
    
    /* Set up CasADi function work vector sizes */
    ssSetNumRWork(S, sz_w);
    ssSetNumIWork(S, sz_iw);
    ssSetNumPWork(S, sz_arg+sz_res);
    ssSetNumNonsampledZCs(S, 0);


    /* Signal that we want to use the CasADi Function */
    mpc_solver_incref();
}

static void mdlInitializeSampleTimes(SimStruct *S)
{
    P("InitializeSampleTimes...");
    ssSetSampleTime(S, 0, INHERITED_SAMPLE_TIME);
    ssSetOffsetTime(S, 0, 0.0);
    // ssSetModelReferenceSampleTimeDefaultInheritance(S); 
}

static void mdlOutputs(SimStruct *S, int_T tid)
{
    P("Outputs");
    /* Read in CasADi function dimensions */
    int_T n_in  = mpc_solver_n_in();
    int_T n_out = mpc_solver_n_out();
    int_T sz_arg, sz_res, sz_iw, sz_w;
    mpc_solver_work(&sz_arg, &sz_res, &sz_iw, &sz_w);
    
    /* Set up CasADi function work vectors */
    void** p = ssGetPWork(S);
    const real_T** arg = (const real_T**) p;
    p += sz_arg;
    real_T** res = (real_T**) p;
    real_T* w = ssGetRWork(S);
    int_T* iw = ssGetIWork(S);
    
    
    /* Point to input and output buffers */
    int_T i;   
    for (i=0; i<n_in;++i) {
      arg[i] = ssGetInputPortRealSignal(S,i);
    }
    for (i=0; i<n_out;++i) {
      res[i] = ssGetOutputPortRealSignal(S,i);
    }

    /* Get a hold on a location to read/write persistant internal memory
    */

    int mem = mpc_solver_checkout();

    /* Run the CasADi function */
    mpc_solver(arg,res,iw,w,mem);

    /* Release hold */
    mpc_solver_release(mem);

}


static void mdlTerminate(SimStruct *S) {
    P("Outputs");
    /* Signal that we no longer want to use the CasADi Function */
    mpc_solver_decref();
}

#ifdef  MATLAB_MEX_FILE    /* Is this file being compiled as a MEX-file? */
#include "simulink.c"      /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"       /* Code generation registration function */
#endif
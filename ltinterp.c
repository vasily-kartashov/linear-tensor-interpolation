#include "mex.h"
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *fs = (double *) mxGetData(prhs[1]);
    double *xi = (double *) mxGetData(prhs[2]);
    
    int m = mxGetM(prhs[2]);
    int n = mxGetN(prhs[2]);
    
    /* parse the grid object */
    mxArray *a_ns      = mxGetField(prhs[0], 0, "ns");
    mxArray *a_axes    = mxGetField(prhs[0], 0, "axes");
    mxArray *a_ix      = mxGetField(prhs[0], 0, "ix");
    mxArray *a_lb      = mxGetField(prhs[0], 0, "lb");
    mxArray *a_ub      = mxGetField(prhs[0], 0, "ub");
    mxArray *a_corners = mxGetField(prhs[0], 0, "corners");
    mxArray *a_cnum    = mxGetField(prhs[0], 0, "cnum");
    mxArray *a_gi2li   = mxGetField(prhs[0], 0, "gi2li");
    mxArray *a_coffs   = mxGetField(prhs[0], 0, "coffs");
    
    int base, i, j, k, l, anchor, *ns, *corners, *cnum, *gi2li, *coffs, cs; 
    double **axes, *ix, *lb, *ub, *roffs, v, *fi;
    
    /* load the data from the grid object */
    axes = (double **) mxMalloc(sizeof(double *) * n);
    for (j = 0; j < n; j++) 
        axes[j] = mxGetData(mxGetCell(a_axes, j));
    
    ns      = (int *) mxGetData(a_ns);
    ix      = (double *) mxGetData(a_ix);
    lb      = (double *) mxGetData(a_lb);
    ub      = (double *) mxGetData(a_ub);
    corners = (int *) mxGetData(a_corners);
    cnum    = (int *) mxGetData(a_cnum);
    gi2li   = (int *) mxGetData(a_gi2li);
    coffs   = (int *) mxGetData(a_coffs);
    
    /* allocate for results */
    plhs[0] = mxCreateDoubleMatrix(m, 1, mxREAL);
    fi = (double *) mxGetData(plhs[0]);
    
    /* allocate memory for relative offsets */
    roffs = (double *) mxMalloc(sizeof(double) * n);
    
    /* loop over all points */
    for (i = 0; i < m; i++)
    {   
        /* get the base of the cell and relative offsets */
        base = 0;
        
        for (j = 0; j < n; j++)
        {
            l = i + m * j;
            
            if (xi[l] <= lb[j])
                anchor = 0;
            else if (xi[l] >= ub[j]) 
                anchor = ns[j] - 2;
            else 
                anchor = floor((xi[l] - lb[j]) * ix[j]);
            
            base += anchor * gi2li[j];
            roffs[j] = (xi[l] - axes[j][anchor]) * ix[j];
        }
        
        /* for each corner compute the contribution */
        cs = *cnum;
        for (k = 0; k < cs; k++)
        {
            /* get the value on the corner */
            v = fs[base + coffs[k]];
            
            /* combine the value depending on corner position */
            for (j = 0; j < n; j++)
                v *= (corners[k + j * cs] == 0) ? 1 - roffs[j] : roffs[j];
                
            /* store the value */
            fi[i] += v;
        }
    }
    
    /* free allocated memory */
    mxFree(roffs);
}
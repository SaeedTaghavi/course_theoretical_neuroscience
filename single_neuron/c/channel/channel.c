/*	channel.c
 *
 *	compute n, m, and h as functions of voltage for HH giant squid axon
 *
 *	N Giordano	July 2006
 *
 *	This program is for the study of the gating parameters in the
 *	Hodgkin-Huxley model of voltage gated ion channels
 *
 *	see book for details
 *
 *	the parameters are the standard ones in the literature for the HH model
 *
 *	The results are written to various files, showing the voltage dependence
 *	of n, m, and h, and also the probability for a Na and a K channel
 *	to be open.  These probabilities are proportional the ion currrent.
 *
 */

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define	PI	3.14159

#define	YES	1
#define	NO	0

double alpha_n(),beta_n();
double alpha_m(),beta_m();
double alpha_h(),beta_h();

double n_K;
double m_NA;
double h_NA;

FILE *fp_n,*fp_m,*fp_h;
FILE *fp_n_4,*fp_m_3_h;

double

main()
{
	double v_min,v_max,v,dv;

	v_min = -100e-3;
	v_max = 100e-3;
	dv = 1e-3;

	fp_n = fopen("n_K","w");
	fp_m = fopen("m_NA","w");
	fp_h = fopen("h_NA","w");

	fp_n_4 = fopen("n_K_4","w");
	fp_m_3_h = fopen("m_NA_3_h","w");

	v = v_min;
	while(v <= v_max) {
		n_K = alpha_n(v) / (alpha_n(v) + beta_n(v));
		m_NA = alpha_m(v) / (alpha_m(v) + beta_m(v));
		h_NA = alpha_h(v) / (alpha_h(v) + beta_h(v));
	
		fprintf(fp_n,"%g\t%g\n",v,n_K);
		fprintf(fp_m,"%g\t%g\n",v,m_NA);
		fprintf(fp_h,"%g\t%g\n",v,h_NA);

		fprintf(fp_n_4,"%g\t%g\n",v,pow(n_K,4.0));
		fprintf(fp_m_3_h,"%g\t%g\n",v,h_NA*pow(m_NA,3.0));

		v += dv;
	}

	fclose(fp_n);
	fclose(fp_m);
	fclose(fp_h);
	fclose(fp_n_4);
	fclose(fp_m_3_h);

}

/*
 *      do K current variables first
 */
double
alpha_n(v,n)
double v;
int n;
{
        double val;

        v *= 1000;      /* convert to mv for now        */
        val = (10.0 - v) / (100.0 * (exp((10-v)/10) - 1.0));
        val *= 1000;

        return(val);
}

double
beta_n(v,n) 
double v;
int n;
{
        double val;

        v *= 1000;      
	val = 0.125 * exp(-v / 80.0);
        val *= 1000;

        return(val);
}

/*
 *      now do the Na current variables
 */
double
alpha_m(v,n)
double v;
int n;
{
        double val;

        v *= 1000;      /* convert to mv for now        */
	val = (25.0 - v) / (10.0 * (exp((25-v)/10) - 1.0));
        val *= 1000;

        return(val);
}

double
beta_m(v,n) 
double v;
int n;
{
        double val;

        v *= 1000;      
	val = 4.0 * exp(-v / 18.0);
        val *= 1000;

        return(val);
}

double
alpha_h(v,n)
double v;
int n;
{
        double val;

        v *= 1000;      /* convert to mv for now        */
	val = 0.07 * exp(-v / 20); 
        val *= 1000;

        return(val);
}

double
beta_h(v,n)
double v;
int n;
{
        double val;

        v *= 1000;
	val = 1.0 / (exp((30-v)/10.0) + 1.0);
        val *= 1000;

        return(val);
}


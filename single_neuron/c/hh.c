/*	hh.c
 *
 *	N Giordano 	July 2006
 *
 *	simulate Hodgkin-Huxley equations for generation of an
 *	action potential
 *
 *	the system is a single isopotential soma that is excited by
 *	an injected current
 *
 *	the soma contains a leak current, and currents from voltage dependent
 *		Na and K ion channels
 *
 *	see book for definitions of all the parameters
 *
 *	all parameters can be varied, but this is not recommended initially
 *		the best way to begin study is to vary the amplitude or the
 *		length of the injected current pulse
 *		The current values give an action potential, but if the
 *		injection current is reduced (the variable "injection_current")
 *		there is no action potential
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

double i_leak();
double i_sodium();
double i_potassium();

double t;
double dt;
double t_start,t_stop;

double c_m_bar,c_m;
double g_leak_bar,g_leak;
double v_leak;
double v_rest;

double g_K_bar,g_K;
double v_K;
double n_K;

double g_NA_bar,g_NA;
double v_NA;
double m_NA;
double h_NA;

double injection_current;
double t_inject,dt_inject;

double area;
double radius;

FILE *fp_v,*fp_na,*fp_k;
FILE *fp_inj;

double

main()
{
	init();
	run();
}

init()
{
	t_stop = 0.010;	/* 0.1;	/*	0.010;	*/
	dt = 0.00001;

	c_m_bar = 1.0e-6;	
	g_leak_bar = 3.0e-4;
	v_leak = 10e-3;

	g_K_bar = 36e-3;
	v_K = -12e-3;

	g_NA_bar = 120e-3;
	v_NA = 115e-3;
	
	radius = 10e-4;
	area = (4/3) * PI * pow(radius,3.0);

	c_m = c_m_bar * area;
	g_leak = g_leak_bar * area;;

	g_K = g_K_bar * area;
	g_NA = g_NA_bar * area;

	v_rest = 0.0;	/*	10.6e-3;	*/
	n_K = alpha_n(v_rest) / (alpha_n(v_rest) + beta_n(v_rest));
	m_NA = alpha_m(v_rest) / (alpha_m(v_rest) + beta_m(v_rest));
	h_NA = alpha_h(v_rest) / (alpha_h(v_rest) + beta_h(v_rest));

	injection_current = 3e-14;  /* 1e-13;	/*	1e-11;	*/
	t_inject = 0.002;
	dt_inject = 0.001;	/* 1;	/*	0.001;	*/

	return;
}


run()
{
	double v;
	double i_inj;
	double factor;

	fp_v = fopen("v_m","w");
	fp_k = fopen("i_k","w");
	fp_na = fopen("i_na","w");
	fp_inj = fopen("i_inj","w");

	factor = dt / c_m;
	v = v_rest;
	t = 0.0;

	while(t < t_stop) {
		if((t >= t_inject) && (t <= t_inject + dt_inject)) {
			i_inj = injection_current;
		}
		else {
			i_inj = 0.0;
		}
		
		v += factor * (i_inj - i_potassium(v) - i_sodium(v) - i_leak(v));
		
		update_n(v);
		update_m(v);
		update_h(v);

		fprintf(fp_v,"%g\t%g\n",t,v);
		fprintf(fp_k,"%g\t%g\n",t,i_potassium(v));
		fprintf(fp_na,"%g\t%g\n",t,i_sodium(v));
		fprintf(fp_inj,"%g\t%g\n",t,i_inj);

		t += dt;
	}

	fclose(fp_v);
	fclose(fp_k);
	fclose(fp_na);
	fclose(fp_inj);

	return;
}


/*      the units for these HH rate parameters are confusing
 *              my units (for v) are Volts, but the literature uses mV
 *      t_factor allows for temperatures different from the standard 6.3 C
 */

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

	if(fabs(v - 10.0) > 1e-6) { 
        	val = (10.0 - v) / (100.0 * (exp((10-v)/10) - 1.0));
	}
	else {
		val = 0.10;
	}
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

double 
i_leak(v)
double v;
{
	double val;

	val = g_leak * (v - v_leak);
	
	return(val);
}

double 
i_potassium(v)
double v;
{
	double val;

	val = g_K * pow(n_K,4.0) * (v - v_K);
	
	return(val);
}

double 
i_sodium(v)
double v;
{
	double val;

	val = g_NA * pow(m_NA,3.0) * h_NA * (v - v_NA);
	
	return(val);
}

update_n(v)
double v;
{
	n_K += dt * alpha_n(v) * (1 - n_K) - dt * beta_n(v) * n_K;
	return;
}

update_m(v)
double v;
{
	m_NA += dt * alpha_m(v) * (1 - m_NA) - dt * beta_m(v) * m_NA;
	return;
}

update_h(v)
double v;
{
	h_NA += dt * alpha_h(v) * (1 - h_NA) - dt * beta_h(v) * h_NA;
	return;
}

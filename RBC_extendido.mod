// =====================================================================
// RBC simple (con trabajo n_t, SIN habitos)  con:
//  shock de preferencias 
//  shock de productividad especifica al capital (IA/automatizacion)
// =====================================================================

%-----------------------------------------------------------
% 1. Variables
%-----------------------------------------------------------
var y c k n i a b epsb;
varexo ea eb ub;

parameters alpha beta delta psi phi rho sigma_e rho_B sigma_B rho_beta sigma_beta;

%-----------------------------------------------------------
% 2. Calibracion
%-----------------------------------------------------------
alpha   = 0.33;
beta    = 0.99;
delta   = 0.025;
phi     = 1;
psi     = 2;
rho     = 0.95;
sigma_e = 0.01;

% --- Shock de IA/automatizacion  ---
rho_B   = 0.95;
sigma_B = 0.01;

% --- Shock de preferencias  ---
rho_beta   = 0.95;
sigma_beta = 0.01;

%-----------------------------------------------------------
% 3. Modelo
%-----------------------------------------------------------
model;

  // (1) Euler con shock de preferencias: 
  exp(c)^(-1) = beta*epsb*exp(c(+1))^(-1)*( alpha*exp(y(+1))/exp(k) + (1-delta) );

  // (2) Condicion intratemporal 
  psi*exp(c)*exp(n)^(1+phi) = (1-alpha)*exp(y);

  // (3) Restriccion de recursos
  exp(c) + exp(k) = exp(y) + (1-delta)*exp(k(-1));

  // (4) Produccion: Y_t = (B_t K_t)^alpha (A_t N_t)^(1-alpha)
  exp(y) = ( exp(b)*exp(k(-1)) )^alpha * ( exp(a)*exp(n) )^(1-alpha);

  // (5) Inversion
  exp(i) = exp(k) - (1-delta)*exp(k(-1));

  // (6) Productividad  
  a = rho*a(-1) + sigma_e*ea;

  // (7) Productividad capital / IA (Bt)
  b = rho_B*b(-1) + sigma_B*eb;

  // (8) Shock de preferencias: 
  epsb = (1-rho_beta) + rho_beta*epsb(-1) + sigma_beta*ub;

end;

%-----------------------------------------------------------
% 4. Estado estacionario 
%-----------------------------------------------------------
steady_state_model;
  Rbar  = 1/beta - 1 + delta;
  kappa = (alpha/Rbar)^(1/(1-alpha));
  n_ss  = ( (1-alpha)*kappa^(alpha-1) / (psi*(kappa^(alpha-1)-delta)) )^(1/(1+phi));
  k_ss  = kappa*n_ss;
  y_ss  = kappa^alpha*n_ss;
  i_ss  = delta*k_ss;
  c_ss  = y_ss - i_ss;

  a    = 0;
  b    = 0;
  epsb = 1;
  k = log(k_ss);
  y = log(y_ss);
  i = log(i_ss);
  c = log(c_ss);
  n = log(n_ss);
end;

shocks;
  var ea = 1;
  var eb = 1;
  var ub = 1;
end;

check;
steady;

stoch_simul(order=1, irf=40, nograph) y c k n i a b epsb;

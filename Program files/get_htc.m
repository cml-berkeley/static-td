function htc_func = get_htc(T_slider,T_disk,h_in)

max_htc = 5e7;
dT = T_slider-T_disk;
dT(dT < 4) = 4;
T_disk(T_disk < 25) = 25;
h_in(h_in<0.1) = 0.1;

k_bulk = 0.0264;
lambda0_bulk = 63.5e-9;
lambda_bulk = lambda0_bulk;
sigma = 0.9;
gamma = 1.4;
Pr = 0.71;
b_air = (2-sigma)/sigma*2*gamma/(gamma+1)/Pr;

k1 = 1.4;
k2 = -0.83;
k3 = -1.93;
b = 12.33;

% Evaluate htc_fun due to phonon
htc_func = exp( k1*(log(T_disk+273.15)-log(273.15+25)) + k2*(log(dT)-log(400)) + k3*log(h_in) + b );

% Evaluate htc_fun due to air
lambda_eff = 3/4.*h_in*1e-9 - h_in.*1e-9/2.*log(h_in*1e-9/lambda_bulk);
k_eff = k_bulk/lambda0_bulk.*lambda_eff;
h_eff = h_in*1e-9 + 2*b_air*lambda_eff;
htc_func = htc_func + k_eff./h_eff;

htc_func(htc_func > max_htc) = max_htc;
htc_func(htc_func < 100) = 100;

end
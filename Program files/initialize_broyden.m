function initialize_broyden(x,x_1,x_2,x_3)

h_in_1 = importdata('gap_initial.dat');
h_in_2 = importdata('gap_initial_BC_1.dat');
h_in_3 = importdata('gap_initial_BC_2.dat');

disk_temp_1 = importdata('disk_temp.dat');
disk_temp_2 = importdata('disk_temp_1.dat');
disk_temp_3 = importdata('disk_temp_2.dat');

slider_temp_1 = importdata('slider_temp.dat');
slider_temp_2 = importdata('slider_temp_1.dat');
slider_temp_3 = importdata('slider_temp_2.dat');

fid_1 = fopen('gap_initial_BC_1.dat', 'w');
fprintf(fid_1,'%15.11f\t%15.11f\t%15.11f\n',h_in_1');
fclose(fid_1);

fid_2 = fopen('gap_initial_BC_2.dat', 'w');
fprintf(fid_2,'%15.11f\t%15.11f\t%15.11f\n',h_in_2');
fclose(fid_2);

fid_3 = fopen('gap_initial_BC_3.dat', 'w');
fprintf(fid_3,'%15.11f\t%15.11f\t%15.11f\n',h_in_3');
fclose(fid_3);

fid_4 = fopen('disk_temp_1.dat', 'w');
fprintf(fid_4,'%15.11f\t%15.11f\t%15.11f\n',disk_temp_1');
fclose(fid_4);

fid_5 = fopen('disk_temp_2.dat', 'w');
fprintf(fid_5,'%15.11f\t%15.11f\t%15.11f\n',disk_temp_2');
fclose(fid_5);

fid_6 = fopen('disk_temp_3.dat', 'w');
fprintf(fid_6,'%15.11f\t%15.11f\t%15.11f\n',disk_temp_3');
fclose(fid_6);

fid_7 = fopen('slider_temp_1.dat', 'w');
fprintf(fid_7,'%15.11f\t%15.11f\t%15.11f\n',slider_temp_1');
fclose(fid_7);

fid_8 = fopen('slider_temp_2.dat', 'w');
fprintf(fid_8,'%15.11f\t%15.11f\t%15.11f\n',slider_temp_2');
fclose(fid_8);

fid_9 = fopen('slider_temp_3.dat', 'w');
fprintf(fid_9,'%15.11f\t%15.11f\t%15.11f\n',slider_temp_3');
fclose(fid_9);


%%
h_next_in = ((x-x_1).*(x-x_2))./((x_3-x_1).*(x_3-x_2)).*h_in_3 ...
    + ((x-x_2).*(x-x_3))./((x_1-x_2).*(x_1-x_3)).*h_in_1 ...
    + ((x-x_1).*(x-x_3))./((x_2-x_1).*(x_2-x_3)).*h_in_2;

disk_temp = ((x-x_1).*(x-x_2))./((x_3-x_1).*(x_3-x_2)).*disk_temp_3 ...
   + ((x-x_2).*(x-x_3))./((x_1-x_2).*(x_1-x_3)).*disk_temp_1 ...
   + ((x-x_1).*(x-x_3))./((x_2-x_1).*(x_2-x_3)).*disk_temp_2;

slider_temp = ((x-x_1).*(x-x_2))./((x_3-x_1).*(x_3-x_2)).*slider_temp_3 ...
   + ((x-x_2).*(x-x_3))./((x_1-x_2).*(x_1-x_3)).*slider_temp_1 ...
   + ((x-x_1).*(x-x_3))./((x_2-x_1).*(x_2-x_3)).*slider_temp_2;

h_next_in(h_next_in<0) = 0;
ele_conv_next_in = get_htc(slider_temp,disk_temp,h_next_in);

%%
fid0 = fopen('Convection_coef_initial_BC.dat', 'w');
fprintf(fid0,'%15.5f\t%15.5f\t%15.5f\n',ele_conv_next_in');
fclose(fid0);

fid1 = fopen('gap_initial.dat', 'w');
fprintf(fid1,'%15.11f\t%15.11f\t%15.11f\n',h_next_in');
fclose(fid1);

fid2 = fopen('disk_temp_initial.dat', 'w');
fprintf(fid2,'%15.11f\t%15.11f\t%15.11f\n',disk_temp');
fclose(fid2);

fid3 = fopen('slider_temp_initial.dat', 'w');
fprintf(fid3,'%15.11f\t%15.11f\t%15.11f\n',slider_temp');
fclose(fid3);
end
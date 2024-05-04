tic 

clear

%% Input Parameters
TFCPower = [1:102,102.1:0.1:106,107:120];
max_iteration = 50;
tol = 1e-3;

for i=1:length(TFCPower)
    
fid_a=fopen('MOAI.txt','w');
fprintf(fid_a,'%8.2f',TFCPower(i));
fclose(fid_a);
disp(['TFC Power: ',num2str(TFCPower(i))])

error_save = zeros(max_iteration,1);
gap_min_initial1 = zeros(max_iteration,1);

main_iteration_flag = 1;
main_iteration_count = 1;

while main_iteration_flag
    fid_b=fopen('main_iteration_count.dat','w');
    fprintf(fid_b,'%15.5f',main_iteration_count');
    fclose(fid_b);

    system('set kmp_stacksize=2048K & "C:\Program Files\ANSYS Inc\v140\ansys\bin\winx64\ansys140.exe" -b -i "C:\Users\siddhesh_sakhalkar\Desktop\Siddhesh Codes\Static touchdown\maincontrol_broyden_loop.mac" -o "C:\Users\siddhesh_sakhalkar\Desktop\Siddhesh Codes\Static touchdown\ANSYS_output.txt" -np 7');
    
    %% Read x and f(x)
    % Read htc into ele_conv_in
    % Read f(htc) into ele_conv_out
    slider_temp_in_read = importdata('slider_temp_initial.dat');
    slider_temp_out_read = importdata('slider_temp.dat');
    disk_temp_in_read = importdata('disk_temp_initial.dat');
    disk_temp_out_read = importdata('disk_temp.dat');
    h_in_read = importdata('gap_initial.dat');
    h_out_read = importdata('gap.dat');
    slider_temp_in = slider_temp_in_read(:);
    slider_temp_out = slider_temp_out_read(:);
    disk_temp_in = disk_temp_in_read(:);
    disk_temp_out = disk_temp_out_read(:);
    h_in = h_in_read(:);
    h_out = h_out_read(:);
    x = [slider_temp_in;disk_temp_in;h_in];
    f = [slider_temp_out;disk_temp_out;h_out];
    
    %% Evaluate next x and save into x_next
    
    % Broyden
    if main_iteration_count == 1
        B = 0.1*speye(2262*3);
        x_next = x - B*(x - f);
    else
        s = x - x_old;
        y = (x - f) - (x_old - f_old);
        B = B_old + (s-B_old*y)*y'/(y'*y);
        x_next = x - B*(x - f);
    end
    
    %% Check for convergence
    error = (x-f)./x;
    error_save(main_iteration_count) = max(abs(error));
    
    disp(['Iteration number: ',num2str(main_iteration_count),' Relative Error: ',num2str(error_save(main_iteration_count))])

    if error_save(main_iteration_count) < tol
        main_iteration_flag = 0; 
    end
    main_iteration_count = main_iteration_count + 1;
    if main_iteration_count > max_iteration
       main_iteration_flag = 0; 
       problem = 1;
    end
    x_old = x;
    f_old = f;
    B_old = B;
    
    %% Write next x into file
    if main_iteration_flag == 1
        slider_temp_next_in_write = reshape(x_next(1:2262),[754,3]);
        disk_temp_next_in_write = reshape(x_next(2263:2262*2),[754,3]);
        h_next_in_write = reshape(x_next(2262*2+1:2262*3),[754,3]);
        h_next_in_write(h_next_in_write<0) = 0; 
        ele_conv_next_in_write = get_htc(slider_temp_next_in_write,disk_temp_next_in_write,h_next_in_write);

        fid1 = fopen('slider_temp_initial.dat', 'w');
        fprintf(fid1,'%15.11f\t%15.11f\t%15.11f\n',slider_temp_next_in_write');
        fclose(fid1);
        fid2 = fopen('disk_temp_initial.dat', 'w');
        fprintf(fid2,'%15.11f\t%15.11f\t%15.11f\n',disk_temp_next_in_write');
        fclose(fid2);
        fid3 = fopen('Convection_coef_initial_BC.dat', 'w');
        fprintf(fid3,'%15.5f\t%15.5f\t%15.5f\n',ele_conv_next_in_write');
        fclose(fid3);
        fid4 = fopen('gap_initial.dat', 'w');
        fprintf(fid4,'%15.11f\t%15.11f\t%15.11f\n',h_next_in_write');
        fclose(fid4);
    end
end

%% Save Input and output
slider_temp_input{1,i} = importdata('slider_temp_initial.dat');
slider_temp_output{1,i} = importdata('slider_temp.dat');

disk_temp_input{1,i} = importdata('disk_temp_initial.dat');
disk_temp_output{1,i} = importdata('disk_temp.dat');  

Convection_coef_input{1,i}=importdata('Convection_coef_initial_BC.dat');
Convection_coef_slider_out{1,i}=importdata('Convection_coef_slider_out.dat');

gap_input{1,i}=importdata('gap_initial.dat');
gap_input2{1,i}=importdata('gap_initial2.dat');
gap_out{1,i}=importdata('gap.dat');
TFC_gap_initial1(i)=min(min(gap_input{1,i}));
TFC_gap_initial2(i)=min(min(gap_input2{1,i}));
TFC_gap_output(i)=min(min(gap_out{1,i}));

%% Initialize

if i==1
    initialize_broyden_linear(TFCPower(i+1),1,0);
elseif i==2
    initialize_broyden(TFCPower(i+1),2,1,0);
elseif i < length(TFCPower)
    initialize_broyden(TFCPower(i+1),TFCPower(i),TFCPower(i-1),TFCPower(i-2));
end

%% Save "Next Input"

gap_initial_BC_1{1,i}=importdata('gap_initial_BC_1.dat');
gap_initial_BC_2{1,i}=importdata('gap_initial_BC_2.dat');
if i>1
    gap_initial_BC_3{1,i}=importdata('gap_initial_BC_3.dat');
end
gap_initial_next_input{1,i}=importdata('gap_initial.dat');

Convection_coef_initial_BC_next_input{1,i}=importdata('Convection_coef_initial_BC.dat');

disk_temp_initial_next_input{1,i}=importdata('disk_temp_initial.dat');
disk_temp_1{1,i}=importdata('disk_temp_1.dat');
disk_temp_2{1,i}=importdata('disk_temp_2.dat');
if i>1
    disk_temp_3{1,i}=importdata('disk_temp_3.dat');
end

slider_temp_initial_next_input{1,i}=importdata('slider_temp_initial.dat');
slider_temp_1{1,i}=importdata('slider_temp_1.dat');
slider_temp_2{1,i}=importdata('slider_temp_2.dat');
if i>1
    slider_temp_3{1,i}=importdata('slider_temp_3.dat');
end

%% Save Output
fid1=fopen('temp_maxdisktemp_main1.dat','r');
maxdisktemp{i}=fscanf(fid1,'%f');
fclose(fid1);
fid1b=fopen('temp_maxdisktemp_main1.dat','w');
fprintf(fid1b,'%15.5f\n',zeros(1,120));
fclose(fid1b);

fid2=fopen('temp_TDStemp_main1.dat','r');
TDStemp{i}=fscanf(fid2,'%f');
fclose(fid2);
fid2b=fopen('temp_TDStemp_main1.dat','w');
fprintf(fid2b,'%15.5f\n',zeros(1,120));
fclose(fid2b);

fid3=fopen('temp_TFCprotrusion_main1.dat','r');
TFCprotrusion{i}=fscanf(fid3,'%f');
fclose(fid3);
fid3b=fopen('temp_TFCprotrusion_main1.dat','w');
fprintf(fid3b,'%15.5f\n',zeros(1,120));
fclose(fid3b);

fid4=fopen('temp_max_CONV_main0.dat','r');
maxconv_0{i}=fscanf(fid4,'%f');
fclose(fid4);
fid4b=fopen('temp_max_CONV_main0.dat','w');
fprintf(fid4b,'%15.5f\n',zeros(1,120));
fclose(fid4b);

fid5=fopen('temp_max_CONV_main1.dat','r');
maxconv_1{i}=fscanf(fid5,'%f');
fclose(fid5);
fid5b=fopen('temp_max_CONV_main1.dat','w');
fprintf(fid5b,'%15.5f\n',zeros(1,120));
fclose(fid5b);

error_array{i}=error_save;

save('test.mat')
end

save('alldata.mat')

toc

%% Plot
for i=1:length(TFCPower)
    for k=2:length(TFCprotrusion{i})
        if TFCprotrusion{i}(k)==0 && TFCprotrusion{i}(k-1)~=0
            finalstep=k-1;
        end
    end
    
    TDS_final_temp(i)=TDStemp{i}(finalstep);
    TFC_final_protrusion(i)=TFCprotrusion{i}(finalstep);
    max_disk_temp_final(i)=maxdisktemp{i}(finalstep);
    max_conv_final_0(i)=maxconv_0{i}(finalstep);
    max_conv_final_1(i)=maxconv_1{i}(finalstep);
end

plot(TFCPower,TDS_final_temp,'LineWidth',2)
xlabel('TFCpower (mW)')
ylabel('TDS Temperature (^o C)')
grid on

figure
plot(TFCPower,max_disk_temp_final,'LineWidth',2)
xlabel('TFCpower (mW)')
ylabel('Disk Temperature (^o C)')
grid on

figure
plot(TFCPower,21.3-TFC_final_protrusion,'LineWidth',2)
xlabel('TFCpower (mW)')
ylabel('Spacing (nm)')
grid on
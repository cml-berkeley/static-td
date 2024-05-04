elex = importdata('ele_x.dat');
eley = importdata('ele_y.dat');

nodes_e(:,1) = elex(:);
nodes_e(:,2) = eley(:);

[nodes,ia,~] = unique(nodes_e,'rows'); % nodes = nodes_e(ia)

elems = zeros(754,3);
for i = 1:754

elems(i,1) = find(nodes(:,1)==elex(i,1) & nodes(:,2)==eley(i,1));
elems(i,2) = find(nodes(:,1)==elex(i,2) & nodes(:,2)==eley(i,2));
elems(i,3) = find(nodes(:,1)==elex(i,3) & nodes(:,2)==eley(i,3));

end

%%
tt = 80;
slider_temp_plot = slider_temp_output{1,tt};
slider_temp_plot_e = slider_temp_plot(:);

slider_temp_plot_nodes = slider_temp_plot_e(ia);

figure
patch('Vertices',[nodes slider_temp_plot_nodes-25],'Faces',elems,'FaceVertexCdata',slider_temp_plot_nodes-25,'FaceColor','interp','linestyle','none');
grid on
xlim([0,840])
xlabel('x (\mum)')
ylabel('y (\mum)')
zlabel('ECS temperature increase (^oC)')
colorbar
colormap jet

figure
patch('Vertices',[nodes slider_temp_plot_nodes],'Faces',elems,'FaceVertexCdata',slider_temp_plot_nodes,'FaceColor','interp');
xlim([600,843.5])
ylim([200,500])
grid on
xlabel('x (\mum)')
ylabel('y (\mum)')
zlabel('T_s')
colorbar
colormap jet
%%
tt = 14;
disk_temp_plot = disk_temp_output{1,tt};
disk_temp_plot_e = disk_temp_plot(:);

disk_temp_plot_nodes = disk_temp_plot_e(ia);

figure
patch('Vertices',[nodes disk_temp_plot_nodes],'Faces',elems,'FaceVertexCdata',disk_temp_plot_nodes,'FaceColor','interp','linestyle','none');
grid on
xlim([0,843.5])
xlabel('x (\mum)')
ylabel('y (\mum)')
zlabel('T_d')
colorbar
colormap jet

figure
patch('Vertices',[nodes disk_temp_plot_nodes],'Faces',elems,'FaceVertexCdata',disk_temp_plot_nodes,'FaceColor','interp');
xlim([600,843.5])
ylim([200,500])
grid on
xlabel('x (\mum)')
ylabel('y (\mum)')
zlabel('T_d')
colorbar
colormap jet

%%
tt = 1;
disk_temp_plot = Convection_coef_output{1,tt};
disk_temp_plot_e = disk_temp_plot(:);

disk_temp_plot_nodes = disk_temp_plot_e(ia);

figure
patch('Vertices',[nodes disk_temp_plot_nodes],'Faces',elems,'FaceVertexCdata',disk_temp_plot_nodes,'FaceColor','interp','linestyle','none');
grid on
xlim([0,843.5])
xlabel('x (\mum)')
ylabel('y (\mum)')
zlabel('T_d')
colorbar
colormap jet

figure
patch('Vertices',[nodes disk_temp_plot_nodes],'Faces',elems,'FaceVertexCdata',disk_temp_plot_nodes,'FaceColor','interp');
xlim([600,843.5])
ylim([200,500])
grid on
xlabel('x (\mum)')
ylabel('y (\mum)')
zlabel('T_d')
colorbar
colormap jet

%%
tt = 80;
gap_plot = gap_out{1,tt};
gap_plot_e = gap_plot(:);

gap_plot_nodes = gap_plot_e(ia);

figure
patch('Vertices',[nodes gap_plot_nodes],'Faces',elems,'FaceVertexCdata',gap_plot_nodes,'FaceColor','interp','linestyle','none');
grid on
xlim([0,840])
xlabel('x (\mum)')
ylabel('y (\mum)')
zlabel('Spacing (nm)')
colorbar
colormap jet

figure
patch('Vertices',[nodes 21.3-gap_plot_nodes],'Faces',elems,'FaceVertexCdata',21.3-gap_plot_nodes,'FaceColor','interp','linestyle','none');
grid on
xlim([0,840])
xlabel('x (\mum)')
ylabel('y (\mum)')
zlabel('TFC Protrusion (nm)')
colorbar
colormap jet
Calculating Nino3.4, AMO, and PDO index from SST using MATLAB
==================================================================

This is a tutorial about using sea surface temperature to calculate Nino3.4, AMO, and PDO index.

Data description
-------------

Here we have HADISST during 1950 to 2018 (828 time points), and ENSO ONI index, AMO index, PDO index derived from long - term ERISST, which are used to evaluate if our calculation is correct.

The code used here to generate Nino3.4, AMO, and PDO is written by me and the EOF code is written by Chad A. Greene.

Step - by -Step code
-------------

Let's load the SST firstly.

```
%% Load data
sst=NaN(360,180,828);
for i=1950:2018
file_here=['sst_' num2str(i)];
load(file_here);
sst(:,:,(1:12)+(i-1950)*12)=sst_here;
end
```

Then we calculate the Nino3.4 index, using the `enso34` function. This function only requires 4 variables, `sst`, which is the 3D SST dataset (lon - lat - Time), `t`, which is a matrix in the size of (Time, 2) and the two columns separately correspond to corresponding years and months, `lon` and `lat`, which are longitude and latitude. It should be noted that the `lon` here should use [0 - 360] format instead of [-180 - 180] format to gain a continuous map.

```
nino34=enso34(sst,date_used,lon,lat);
```

Is our calculation correct? Let's compare it with ONI index.

```
load('enso_line');
h1=plot(1:828,nino34,'b');
hold on
h2=plot(1:828,enso_line(:,3),'r');
set(gca,'xtick',[]);
legend([h1 h2],{'Our Nino34','ONI'});
ylim([-3 3]);
set(gca,'fontsize',14,'fontweight','bold');
```
![Image text](https://github.com/ZijieZhaoMMHW/Cal_CM/blob/master/example_nino34.png)

Basically the same. Let's calculate the correlation.
```
corr([nino34 enso_line(:,3)])
ans =
    1.0000    0.9837
    0.9837    1.0000
```

Very high correlation.

Then we calculate the AMO index, the code is basically the same as what used in Nino34.

```
amo_idx=amo(sst,date_used,lon,lat);
```

Compare it with AMO index from ERISST.

![Image text](https://github.com/ZijieZhaoMMHW/Cal_CM/blob/master/example_amo.png)

Very similar. Look at their correlation.

```
corr([amo_idx amo_line(:,3)])
ans =
    1.0000    0.9336
```

Still very high.

Then we move to calculate the PDO index. There is new variable in function `pdo` which is the `land_mask`, which is 1 if the corresponding grid is ocean and NaN otherwise.

```
[pdo_p,pdo_idx,lon_pdo,lat_pdo]=pdo(sst,t,lon,lat,land_index);
```
Output `pdo_p` is the PDO SST pattern, `pdo_idx` is the PDO index, `lon_pdo` and `lat_pdo` is the domain for PDO regions.

 ```
 load('pdo_line');

subplot(2,1,1);
m_proj('miller','lon',[nanmin(lon_pdo) nanmax(lon_pdo)],'lat',[nanmin(lat_pdo) nanmax(lat_pdo)]);
m_pcolor(lon_pdo,lat_pdo,pdo_p');
shading flat
colormap(jet);
m_coast('patch',[0 0 0]);
m_grid('xtick',[],'ytick',[]);
 
subplot(2,1,2);
load('pdo_line');
h1=plot(1:828,pdo_idx,'b');
hold on
h2=plot(1:828,[pdo_line(:,3); NaN(12,1)],'r');
set(gca,'xtick',[]);
legend([h1 h2],{'Our PDO','PDO'});
ylim([-3 3]);
set(gca,'fontsize',14,'fontweight','bold');
 ```
![Image text](https://github.com/ZijieZhaoMMHW/Cal_CM/blob/master/example_pdo.png)





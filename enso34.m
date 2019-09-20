function idx = enso34(sst,t,lon,lat)
%% Set defaults: 
sst=sst(lon>=190 & lon<=240,lat<=5 & lat>=-5,:);
lon=lon(lon>=190 & lon<=240);
lat=lat(lat<=5 & lat>=-5);

area_used=repmat(cosd(lat'),length(lon),1);
sst_line=NaN(size(sst,3),1);

for i=1:length(sst_line);
    sst_here=sst(:,:,i).*area_used;
    sst_line(i)=nanmean(sst_here(:));
end

%% Calculate ENSO index: 

% The pre-moving-averaged index is just the sst anomaly: 
idx=NaN(length(sst_line),1);
for i=1:12;
    index_here=t(:,2)==i;
    idx(index_here)=sst_line(index_here)-nanmean(sst_line(index_here));
end
idx=detrend(idx,1);
idx=smoothdata(idx,1,'movmean',5);





function idx = amo(sst,t,lon,lat)
%% Set defaults: 
sst=sst(lon>=285 | lon<=5,lat<=70 & lat>=0,:);
lon=lon(lon>=285 | lon<=5);
lat=lat(lat<=70 & lat>=0);

area_used=repmat(cosd(lat'),length(lon),1);
sst_line=NaN(size(sst,3),1);

for i=1:length(sst_line);
    sst_here=sst(:,:,i).*area_used;
    sst_line(i)=nanmean(sst_here(:));
end

%% Calculate AMO index: 

% The pre-moving-averaged index is just the sst anomaly: 
idx=NaN(length(sst_line),1);
for i=1:12;
    index_here=t(:,2)==i;
    idx(index_here)=sst_line(index_here)-nanmean(sst_line(index_here));
end
idx=detrend(idx,1);
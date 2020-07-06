%% HACER INSPECCION MANUAL DE LAS VENTANAS (rechazo_comp_1)

%% RECHAZO ARTEFACTOS (databrowser)
%%%% problema!!!! D:

%% cargar data
path    = 'E:\DatosPsiquiatrico\Procesados\RS3\';
file    = 'CNTF_0001_R1.mat';
data    = load([path,file]);

if ~isempty(strfind(file, 'R1'))
    dataFIC = data.DATAEEGOPEN;
else
    dataFIC = data.DATAEEGCLOSE;
end

%% Seleccionar artefactos manualmente

% first select only the EEG channels
% cfg         = [];
% cfg.channel = 'EEG';
% data        = ft_preprocessing(cfg,dataFIC);

% open the browser and page through the trials
cfg_browser              = [];
% cfg.channel      = 'EEG';
cfg_browser.viewmode     = 'vertical';
%cfg.continuous   = 'no';
%cfg.allowoverlap = 'yes';
cfg_browser.blocksize = 10; % time window to browser
cfg_browser.artifactalpha = 0.8;  % this make the colors less transparent and thus more vibrant
cfg_browser.artfctdef.blinks.artifact     = [];
cfg_browser.artfctdef.muscle.artifact     = [];
artif = ft_databrowser(cfg_browser,dataFIC);
% cfg              = ft_databrowser(cfg,dataFIC);

% ft_preprocessing(cfg, dataFIC);
% ft_rejectartifact(cfg, dataFIC);

cfg = [];
cfg.artfctdef.minaccepttim = 0.010;
cfg.artfctdef.reject       = 'partial';
if isfield(artif.artfctdef,'visual')
    cfg.artfctdef.visual.artifact = artif.artfctdef.visual.artifact;
end
if isfield(artif.artfctdef,'muscle')
    cfg.artfctdef.muscle.artifact = artif.artfctdef.muscle.artifact;
end
data = ft_rejectartifact(cfg, dataFIC);

% volver la data a un trial continuo
% rejectartifact lo deja discontinuo pues elimina los segmentos
% selecccionados

cfg = [];
cfg.trl = [min(data.sampleinfo(:,1)) max(data.sampleinfo(:,2)) 0];
data = ft_redefinetrial(cfg,data);

ft_databrowser(cfg_browser,data);

% save([path, file(1:end-15), '_REJECT_COMP.mat'],'dataFIC') ; % POST
% REJECT

% save([path, file(1:end-15), '_REJECT_COMP.mat'],'REJECT_COMP'); % POST

%% Downsampling a 256 Hz (no menor a 1.5 del tamanho senhal) (ica.m)

%% Descomposicion ICA (ica.m)

%% Rechazo comp ica (ica2.m)

%% correccion de linea base --> el promedio lo corrigen (conectivity.m)

%% calculo de la conectividad (conectivity.m)
close all; clear all; clc;
load('..\data\params.mat');
params.num_particles = 300;
params.hist_bin = 8;

params.model = 1;
params.alpha = 0;
params.sigma_velocity = 1;
params.initial_velocity = [8,0];
params.sigma_position = 15;
params.sigma_observe = 0.5;
condensationTracker('video3',params);
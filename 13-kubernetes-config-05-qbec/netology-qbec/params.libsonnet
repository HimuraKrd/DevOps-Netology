
// this file returns the params for the current qbec environment
local env = std.extVar('qbec.io/env');

local base = import './environments/base.libsonnet';


local default = import './environments/default.libsonnet';
local stage = import './environments/stage.libsonnet';
local prod = import './environments/prod.libsonnet';

local paramsMap = {
    _: base,
    default: default,
    stage: stage,
    prod: prod,
};


#if std.objectHas(paramsMap, key) then paramsMap[key] else error 'no param file %s found for environment %s' % [key, env]
if std.objectHas(paramsMap, env) then paramsMap[env] else error 'environment ' + env + ' not defined in ' + std.thisFile
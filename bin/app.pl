#!/usr/bin/env perl
use Dancer;
use Dancer::Plugin::Database;
use SDVentures::App;
use DateTime;

set serializer => 'JSON';

get '/device_types' => sub {
  my @device_types = database->quick_select('device_types', {});
  return {device_types => @device_types};
};

get '/devices' => sub {
  my @devices = database->quick_select('devices', {});
  return {devices => @devices};
};

get '/readings' => sub {
  my @readings = database->quick_select('readings', {});
  return {readings => @readings};
};

any ['get', 'post'] => '/devices/:device_mac_addr/readings' => sub {
  if (request->is_post()) {
    database->quick_insert('readings', {value => params->{'value'}, device_mac_addr => params->{'device_mac_addr'}, created_at => DateTime->now()});
    return {status => 'ok'}
  } else {
    my @readings = database->quick_select('readings', {device_mac_addr => params->{'device_mac_addr'}});
    return {readings => @readings};
  }
};

dance;

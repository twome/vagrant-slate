#!/usr/bin/env ruby
require 'fileutils'
include FileUtils

%x( ll )
%x( echo | git flow init )
#!/usr/bin/env ruby

require 'fileutils'
include FileUtils

%x( serve & )
%x( guard -p -l 10 )

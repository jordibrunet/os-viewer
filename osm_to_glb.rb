#!/usr/bin/env ruby
# Usage:  ruby osm_to_glb.rb my_model.osm out.glb

require 'openstudio'

unless ARGV.size == 2
  abort "USAGE: ruby osm_to_glb.rb input.osm output.glb"
end

input_path  = OpenStudio::Path.new(ARGV[0])
output_path = OpenStudio::Path.new(ARGV[1])

model = OpenStudio::Model::Model.load(input_path)
abort "❌  Could not load #{input_path}" if model.empty?

translator = OpenStudio::Gltf::GltfForwardTranslator.new
ok = translator.modelToGLTF(model.get, output_path)   # returns true/false :contentReference[oaicite:0]{index=0}

puts(ok ? "✅  Wrote #{output_path}" : "❌  Translation failed")

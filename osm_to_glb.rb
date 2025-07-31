#!/usr/bin/env ruby
# Usage:
#   ruby osm_to_glb.rb input.osm out.glb
#   Also write out_spaces.csv in the same folder containing wich spaces are part of total floor area and which not

require 'openstudio'
require 'csv'

# ── CLI ------------------------------------------------------------------
unless ARGV.size == 2
  abort "USAGE: ruby osm_to_glb.rb input.osm output.glb"
end

input_path  = OpenStudio::Path.new(ARGV[0])
output_glb  = OpenStudio::Path.new(ARGV[1])
csv_path    = File.join(File.dirname(output_glb.to_s),
                        File.basename(output_glb.to_s, '.*') + '_spaces.csv')

# ── load OSM -------------------------------------------------------------
model = OpenStudio::Model::Model.load(input_path)
abort "❌  Could not load #{input_path}" if model.empty?
model = model.get

# ── export GLB -----------------------------------------------------------
translator = OpenStudio::Gltf::GltfForwardTranslator.new
ok = translator.modelToGLTF(model, output_glb)

puts(ok ? "✅ wrote #{output_glb}" : "❌ GLB translation failed")

# ── build CSV ------------------------------------------------------------
CSV.open(csv_path, 'w', headers: %w[SpaceName PartOfTotalFloorArea],
                       write_headers: true) do |csv|
  model.getSpaces.each do |sp|
    csv << [sp.nameString,
            sp.partofTotalFloorArea ? 'true' : 'false']
  end
end
puts "✅ wrote #{csv_path}"

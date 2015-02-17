include_recipe "nexus::default"

nexus_capability "yum.generate" do
    properties  "repository" => "releases"
end

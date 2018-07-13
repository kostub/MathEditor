# Needed due to
# http://stackoverflow.com/questions/33395675/cocoapods-file-reference-is-a-member-of-multiple-groups
install! 'cocoapods', :deterministic_uuids => false

target 'MathEditor_Example' do
  pod 'MathEditor', :path => './'
end
target 'MathEditor_Tests' do
  pod 'MathEditor', :path => './'
end
target 'MathEditor' do
    # Kellyroach/fix warnings (#103) has been approved and merged onto iosMath master
    # at commit = 4f46aff6b745676ff3d98752bb7f5189fc448843 , but isn't released on
    # COCOAPODS.ORG yet.  Temporarily, modify Podfile on our branch to point to this commit.
    pod 'iosMath', :git => 'https://github.com/kostub/iosMath.git', :commit => '4f46aff6b745676ff3d98752bb7f5189fc448843'
end

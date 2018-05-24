tree = [
    [1, 56, '57.59'],
    [1, 57, '58'],
    [1, 59, '60.61'],
    [1, 61, '62']
]
dict = tree.each_with_object({}) do |row, struct|
  struct[row[1].to_s] = row[2]
end
# noinspection RubyDynamicConstAssignment

CATEGORIES = { '62' => 'Brakes check',
               '60' => 'Oil change',
               '56' => 'All',
               '61' => 'Maintenance',
               '57' => 'Physical',
               '59' => 'Service',
               '58' => 'Vehicule' }.freeze

def generate_tree(dict, root, tree = {})
  path = dict.fetch(root, '').split('.')
  tree[root] = { id: root, name: CATEGORIES[root], children: [] }
  path.each do |child|
    tree[root][:children].push(generate_tree(dict, child, tree))
    # perhaps make the sum here
  end
  tree[root]
end

R = generate_tree(dict, '56')


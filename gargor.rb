# generations: set > 1
max_generations 10

# individuals number of some generation.
population 10

# elite number of some generation.(carried over)
elite 1

# Probability of mutation　set "0.01" to "1%" (when crossover)
mutation 0.01

# target cook command : '%s' will replace by node name.
target_cooking_cmd "vagrant provision"

# target nodes
#   performing target_cooking_command before the attack.
target_nodes ["spitesting.local"]

# attack command
attack_cmd "vagrant ssh -- ab -n 10 -c 1 http://spitesting.local/"


# evalute of the attack
# code: exit code of attack_cmd command (0 => succees)
# out:  standard output of attack_cmd command
# time: execute time of attack_cmd
evaluate do |code,out,time|
  puts out
  fitness = 0
  fitness = 1/time
  # get "FAILED" count from stadard output of stress-tool,
  # and set fitess to 0 when FAILED > 0.
  if time > 0 && code == 0 && /^FAILED (\d+)/ =~ out && $1 == "0"
    # get fitness from stadard output of stress-tool.
    # e.g.: request count:200, concurrenry:20, 45.060816 req/s
    if /, ([.\d]+) \[#\/sec\]/s =~ out
      fitness = $1.to_f
    end
    # To get fitness simply,to use execution time
    # fitness = 1/time
  end
  # This block must return the fitness.(integer or float)
  fitness
end

# definition of parameters(GA)
#
# param _name_ do
# json_file: Chef parameter(JSON) file (such as  nodes/*.json or roles/*.json)
#            (Warning!) gargor will overwrite their json files.
# json_path: to locate the value by JSONPath
# mutaion:   to set value when mutaion
param "innodb_buffer_pool_size" do
  json_file "infrastructure/drupal_lamp.json"
  json_path '$.mysql.tunable.innodb_buffer_pool_size'
  mutation rand(500) * 1049000
end

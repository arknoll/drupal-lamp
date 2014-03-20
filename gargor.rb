# generations: set > 1
max_generations 30

# individuals number of some generation.
population 30

# elite number of some generation.(carried over)
elite 1

# Probability of mutation　set "0.01" to "1%" (when crossover)
mutation 0.03

# target cook command : '%s' will replace by node name.
target_cooking_cmd "vagrant provision"

# target nodes
#   performing target_cooking_command before the attack.
target_nodes ["spitesting.local"]

# attack command
attack_cmd "vagrant ssh -- ab -n 10 -c 2 http://localhost/"


# evalute of the attack
# code: exit code of attack_cmd command (0 => succees)
# out:  standard output of attack_cmd command
# time: execute time of attack_cmd
evaluate do |code,out,time|
  puts out
  fitness = 0
  # get "FAILED" count from stadard output of stress-tool,
  # and set fitess to 0 when FAILED > 0.
  if time > 0 && code == 0
    # get fitness from stadard output of stress-tool.
    # e.g.: request count:200, concurrenry:20, 45.060816 req/s
    if /([.\d]+) \[#\/sec\]/s =~ out
      fitness = $1.to_f
    end
    if /Failed requests:\s+(\d+)/s =~ out
      if $1.to_f > 0
        fitness = 0
      end
    end
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

# param 'startservers' do
#   json_file 'infrastructure/drupal_lamp.json'
#   json_path '$.apache.prefork.startservers'
#   mutation rand(25)
# end

# param 'minspareservers' do
#   json_file 'infrastructure/drupal_lamp.json'
#   json_path '$.apache.prefork.minspareservers'
#   mutation rand(25)
# end

# param 'maxspareservers' do
#   json_file 'infrastructure/drupal_lamp.json'
#   json_path '$.apache.prefork.maxspareservers'
#   mutation rand(25)
# end

# param 'maxclients' do
#   json_file 'infrastructure/drupal_lamp.json'
#   json_path '$.apache.prefork.maxclients'
#   mutation rand(25)
# end

# param 'serverlimit' do
#   json_file 'infrastructure/drupal_lamp.json'
#   json_path '$.apache.prefork.serverlimit'
#   mutation rand(25)
# end

# param 'keepalivetimeout' do
#   json_file 'infrastructure/drupal_lamp.json'
#   json_path '$.apache.prefork.keepalivetimeout'
#   mutation rand(10)
# end

# param 'maxkeepaliverequests' do
#   json_file 'infrastructure/drupal_lamp.json'
#   json_path '$.apache.prefork.maxkeepaliverequests'
#   mutation rand(5000)
# end

param 'innodb_flush_log_at_trx_commit' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.innodb_flush_log_at_trx_commit'
  mutation rand(0..2)
end

param 'max_allowed_packet' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.max_allowed_packet'
  mutation rand(1024..5242880)
end

param 'max_connect_errors' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.max_connect_errors'
  mutation rand(1..2000000)
end

param 'tmp_table_size' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.tmp_table_size'
  mutation rand(1024..6713600)
end

param 'max_heap_table_size' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.max_heap_table_size'
  mutation rand(16384..6713600)
end

param 'query_cache_type' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.query_cache_type'
  mutation rand(0..2)
end

param 'max_connections' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.max_connections'
  mutation rand(1..10000)
end

param 'thread_cache_size' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.thread_cache_size'
  mutation rand(0..16384)
end

param 'open_files_limit' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.open_files_limit'
  mutation rand(0..131070)
end

param 'table_definition_cache' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.table_definition_cache'
  mutation rand(400..40960)
end

param 'table_open_cache' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.table_open_cache'
  mutation rand(1..40960)
end

param 'innodb_file_per_table' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.innodb_file_per_table'
  mutation rand(0..1)
end

param 'innodb_buffer_pool_size' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.innodb_buffer_pool_size'
  mutation rand(500) * 1049000
end

param 'query_cache_size' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.query_cache_size'
  mutation rand(0..24) * 1049000
end

param 'table_cache' do
  json_file 'infrastructure/drupal_lamp.json'
  json_path '$.mysql.tunable.table_cache'
  mutation rand(1..15120)
end

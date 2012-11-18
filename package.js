Package.describe({
  summary: "text comparison tools"
});

Package.on_use(function (api, where) {
  api.use(['underscore'], 'client');
  api.add_files('text-tools.js', 'client');
  api.add_files('double_metaphone.js', 'client');
  api.add_files('cats_code_1.js', 'client');
});

Package.on_test(function (api) {
  api.use('tinytest');
  api.add_files('text_tools_tests.js', 'client');
  api.add_files('double_metaphone_tests.js', 'client');
  api.add_files('cats_code_1_tests.js', 'client');
});

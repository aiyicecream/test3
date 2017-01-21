1. When you're running specs, you're running RSpec like an application and it's "config" is in spec/spec_helper.rb. I'll assume it's empty/irrelevant.

2. If you're running a more recent version of RSpec, you can just place `--require spec_helper` in your `.rspec` file and you won't need the `require "spec_helper"` in your files.

3. It's best to use `RSpec.describe` instead of plain `describe` the first time in a file.

4. You can use a `subject` block for more readability along with `described_class`. It also lets you use `it { is.expected_to` syntax

5. `describe` can take a class name instead of a string. This way it makes it obvious if you've required the file or not. If you pass a class, then `subject` becomes implicit.
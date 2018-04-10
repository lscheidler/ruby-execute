require "spec_helper"

describe Execute do
  it "has a version number" do
    expect(Execute::VERSION).not_to be nil
  end

  describe Execute do
    describe 'execute' do
      it 'should execute command' do
        status = Execute.execute ['echo', 'hello world']

        expect(status.class).to eq(Execute::ExtendedStatus)
        expect(status.stdout).to eq("hello world\n")
        expect(status.stdout_lines).to eq(['hello world'])
      end

      it 'shouldn\'t execute command, because of dryrun' do
        status = Execute.execute ['echo', 'hello world'], dryrun: true

        expect(status.class).to eq(Execute::ExtendedStatus)
        expect(status.stdout).to eq('echo hello world')
        expect(status.stdout_lines).to eq(['echo hello world'])
      end

      it 'should execute command with an environment variable' do
        status = Execute.execute ['env'], env: {'TEST' => 'env:test'}

        expect(status.class).to eq(Execute::ExtendedStatus)
        expect(status.stdout).to match(/^TEST=env:test$/)
        expect(status.stdout_lines).to include('TEST=env:test')
      end

      it 'should print command line' do
        expect {
          Execute.execute ['echo', 'hello world'], print_cmd: true
        }.to output(/echo hello world/).to_stdout
      end

      it 'should print output' do
        expect {
          Execute.execute ['echo', 'hello world'], print_lines: true
        }.to output("hello world\n").to_stdout
      end

      it 'should raise an exception' do
        expect {
          Execute.execute ['false'], raise_exception: true
        }.to raise_error(Execute::ExecutionFailedException)
      end
    end
  end
end

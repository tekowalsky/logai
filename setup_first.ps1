# Salesforce LogAI installation:

# git clone https://github.com/salesforce/logai.git
# cd logai

# Add the local path to the PYTHONPATH environment variable
$env:PYTHONPATH = '.'
# For Bash use the following instead:
# export PYTHONPATH='.'

# Use "rustup" from https://rustup.rs/  to install Rust (the officially supported installation method for the Rust compiler)
$check = $(read-host("Have you installed Rust using 'rustup'(y/n)?")).tolower()
if($check -ne 'y'){
    throw("You must install Rust using https://rustup.rs/ before continuing.")
}

if($(read-host("Do dev in the root (y/n)?")).tolower() -eq 'y'){
    python -m venv .venv
    ./.venv/scripts/activate.ps1
    python -m pip install pip-tools
    python -m pip-compile dev-requirements.in
    python -m pip install -r dev-requirements.txt
    # Use "rustup" from https://rustup.rs/  to install Rust (the officially supported installation method for the Rust compiler)
    $env:RUSTUP_HOME = "d:\users\akrop\.rustup;"
    $env:CARGO_HOME = "d:\users\akrop\.cargo;"
    $env:PATH=$env:PATH + 'd:\users\akrop\.cargo\bin;'
    if($(read-host("Do you have a CUDA-capable GPU (y/n)?")).tolower() -eq 'y'){
        $env:RUSTFLAGS = '-C target-cpu=native -C target-feature=+crt-static'
    }
    
    # Run the following, then move 'c:\users\{my username}\appdata\roaming\nltk' to './venv/'
    python -m nltk.downloader punk_tab -d ./.venv/nltk_data
    # or
    # python -m nltk.downloader all -d ./.venv/nltk_data
    if($(test-path ~\AppData\Roaming\nltk)){
        "Moving 'c:\users\{my username}\appdata\roaming\nltk' to './venv/'"
        move-item ~\AppData\Roaming\nltk .\.venv
    }
    # set the following environment variable to the location of the 'nltk_data' directory.
    $env:NLTK_DATA="d:\source\forks\logai\app\.venv\nltk_data"

    if($(read-host("Build Sphix documentation (y/n)?")).tolower() -eq 'y'){
        set-location ./docs 
        make clean
        make html
    }
else{
    set-location ./app
    python -m venv .venv
    ./.venv/scripts/activate.ps1
    python -m pip install pip-tools
    python -m pip-compile
    python -m pip install -r requirements.txt

    # Use "rustup" from https://rustup.rs/  to install Rust (the officially supported installation method for the Rust compiler)
    $env:RUSTUP_HOME = "d:\users\akrop\.rustup;"
    $env:CARGO_HOME = "d:\users\akrop\.cargo;"
    $env:PATH=$env:PATH + 'd:\users\akrop\.cargo\bin;'
    if($(read-host("Do you have a CUDA-capable GPU(y/n)?")).tolower() -eq 'y'){
        $env:RUSTFLAGS = '-C target-cpu=native -C target-feature=+crt-static'
    }
    
    # Run the following, then move 'c:\users\{my username}\appdata\roaming\nltk' to './venv/'
    python -m nltk.downloader punk_tab -d ./.venv/nltk_data
    # or
    # python -m nltk.downloader all -d ./.venv/nltk_data
    if($(test-path ~\AppData\Roaming\nltk)){
        "Moving 'c:\users\{my username}\appdata\roaming\nltk' to './venv/'"
        move-item ~\AppData\Roaming\nltk .\.venv
    }
    # set the following environment variable to the location of the 'nltk_data' directory.
    $env:NLTK_DATA="d:\source\forks\logai\app\.venv\nltk_data"

    "To start LogAI service locally, run the following command:"
    "python ./app/application.py"
}
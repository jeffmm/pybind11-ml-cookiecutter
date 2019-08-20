#! /bin/bash

# Push scaffolded repo to GitHub
echo "Making initial commit"
git init
git add .
git commit -m "Scaffold repo"


# Push scaffolded repo to GitHub
if [ '{{ cookiecutter.github_access_token }}' != "" ]; then

    # Register repo on GitHub using repo owner's account
    echo "Registering repo on GitHub"
    curl -H 'Authorization: token {{ cookiecutter.github_access_token }}' https://api.github.com/user/repos -d '{"name":"{{ cookiecutter.repo_name }}","private":true}'

    echo "Pushing to GitHub"
    # Add the repo using ssh or https
    github_connection="None"
    while [ "$github_connection" != "ssh" ] && [ "$github_connection" != "https" ]
    do
        read -p "GitHub connection type (ssh/https) [ssh]: " github_connection
        # Replace null value with default
        github_connection=${github_connection:-ssh}

        if [ "$github_connection" == "ssh" ]; then
            git remote add origin  git@github.com:{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}.git
        elif [ "$github_connection" == "https" ]; then
            git remote add origin https://github.com/{{ cookiecutter.repo_owner }}/{{ cookiecutter.repo_name }}.git
        fi

    done
    git push -u origin master
    echo "Done."

    # Set up travis CI
    if [ '{{ cookiecutter.travis_access_token }}' != "" ]; then
        body='{
        "request": {
        "branch":"master"
        }}'
        curl -s -X POST \
           -H "Content-Type: application/json" \
           -H "Accept: application/json" \
           -H "Travis-API-Version: 3" \
           -H "Authorization: token {{ cookiecutter.travis_access_token }}" \
           -d "$body" \
           https://api.travis-ci.com/repo/travis-ci%2Ftravis-core/requests
   else
        echo "No Travis CI API key provided."
    fi
else
    echo "No GitHub API key provided."
fi


# Environment
env_file=.env
echo "" >> $env_file
echo "# Environment variables for docker containers." >> $env_file
# github access token
echo "GITHUB_ACCESS_TOKEN={{ cookiecutter.github_access_token }}" >> $env_file

echo "Finished repo initialization. Run the start.sh script to launch project docker containers."

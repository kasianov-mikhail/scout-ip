set -e # fails build if any command fails

if [ ${CI_XCODEBUILD_EXIT_CODE} != 0 ]
then
    exit 1
fi

if [[ -n $CI_APP_STORE_SIGNED_APP_PATH ]]; # checks if there is an AppStore signed archive after running xcodebuild
then
    BUILD_TAG=${CI_BUILD_NUMBER}
    VERSION=$(cat ../${CI_PRODUCT}.xcodeproj/project.pbxproj | grep -m1 'MARKETING_VERSION' | cut -d'=' -f2 | tr -d ';' | tr -d ' ')

    git tag $VERSION\-$BUILD_TAG

    git push --tags https://${GIT_AUTH}@github.com/kasianov-mikhail/scout-ip.git
fi

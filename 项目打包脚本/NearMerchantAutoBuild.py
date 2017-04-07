#usage
# 1. open the terminal client and switch to your project directory
# 2. input the cmd: python NearMerchantAutoBuild.py -w workspaceName.xcworkspace -s 
#                    schemeName -t NerMerchant -o ipaFilePath(~/Desktop/NearMerchant.ipa)

from optparse import OptionParser
import subprocess
import requests

#iOS build setting
<<<<<<< HEAD
CODE_SIGN_IDENTITY = "iPhone Distribution: Beijing Qfpay Technology Company Limited"
PROVISIONING_PROFILE = "2da3c03f-03c6-416b-b7cc-6ab4d7545476"
CONFIGURATION = "Release"
SDK = "iphoneos"

#pgyer setting
PGYER_UPLOAD_URL 		= "http://www.pgyer.com/apiv1/app/upload"
PGYER_DOWNLOAD_BASE_URL = "http://www.pgyer.com/testbuild"
PGYER_USER_KEY 			= "7d4cb77ecf7fe27b250d9949b4ef1a75"
PGYER_API_KEY 			= "7a08b9b25a3d43ff8739da7610a00be0"
PGYER_INSTALL_PWD		= ""
PGYER_PUBLISH_RANGE 	= "2"   #2:distribute directly      3:only I install
PGYER_IS_PUBLISH_PUBLIC = "1" #is distribute to public
PGYER_UPDATE_DES     	= ""    #desc for version update
=======
CODE_SIGN_IDENTITY = "iPhone Distribution: Beijing Qfpay Technology Company Limited" # certification
PROVISIONING_PROFILE = "2da3c03f-03c6-416b-b7cc-6ab4d7545476"                        # profile
CONFIGURATION = "Release"                                                            # configuration
SDK = "iphoneos"                                                                     # device

#pgyer setting
PGYER_UPLOAD_URL 		= "http://www.pgyer.com/apiv1/app/upload" # pgy's upload api
PGYER_DOWNLOAD_BASE_URL = "http://www.pgyer.com/testbuild"   # app's download url, need change
PGYER_USER_KEY 			= "7d4cb77ecf7fe27b250d9949b4ef1a75" # ...
PGYER_API_KEY 			= "7a08b9b25a3d43ff8739da7610a00be0" # dy's private key
PGYER_INSTALL_PWD		= ""
PGYER_PUBLISH_RANGE 	= "2"   # 2: distribute directly      3: only I install
PGYER_IS_PUBLISH_PUBLIC = "1"   # 1: distribute to public     2: distribute to my account
PGYER_UPDATE_DES     	= ""    # desc for version update
>>>>>>> 08b9c27caeff6717259f7e4910800a615f609d06

#clean build dir
def cleanBuildDir(buildDir):
	cleanCmd = "rm -r %s" %(buildDir)
	process = subprocess.Popen(cleanCmd, shell = True)
	process.wait()
	print "cleaned buildDir: %s" %(buildDir)

#define upload result log
def parserUploadResult(jsonResult):
	resultCode = jsonResult['code']
	if resultCode == 0:
		downUrl = PGYER_DOWNLOAD_BASE_URL +"/"+jsonResult['data']['appShortcutUrl']
		print "Upload Success"
		print "DownUrl is:" + downUrl
	else:
		print "Upload Fail!"
		print "Reason:"+jsonResult['message']

#upload ipa file to pgyer

def uploadIpaToPgyer(ipaPath):
    print "ipaPath:"+ipaPath
    files = {'file': open(ipaPath, 'rb')}
    headers = {'enctype':'multipart/form-data'}
<<<<<<< HEAD
    payload = {'uKey':PGYER_USER_KEY,'_api_key':PGYER_API_KEY,'file':ipaPath,'publishRange':PGYER_PUBLISH_RANGE,'isPublishToPublic':PGYER_IS_PUBLISH_PUBLIC, 'password':PGYER_INSTALL_PWD}
=======
    payload = {'uKey':PGYER_USER_KEY,'_api_key':PGYER_API_KEY,'file':output,'publishRange':PGYER_PUBLISH_RANGE,'isPublishToPublic':PGYER_IS_PUBLISH_PUBLIC, 'password':PGYER_INSTALL_PWD}
>>>>>>> 08b9c27caeff6717259f7e4910800a615f609d06
    print "uploading...."
    r = requests.post(PGYER_UPLOAD_URL, data = payload ,files=files,headers=headers)
    print r
    if r.status_code == requests.codes.ok:
         result = r.json()
         parserUploadResult(result)
    else:
        print 'HTTPError,Code:'+ str(r.status_code)

#build project ( no pod)
def buildProject(project, target, output):
	buildCmd = 'xcodebuild -project %s -target %s -sdk %s -configuration %s build CODE_SIGN_IDENTITY="%s" PROVISIONING_PROFILE="%s"' %(project, target, SDK, CONFIGURATION, CODE_SIGN_IDENTITY, PROVISIONING_PROFILE)
	process = subprocess.Popen(buildCmd, shell = True)
	process.wait()

	signApp = "./build/%s-iphoneos/%s.app" %(CONFIGURATION, target)
	signCmd = "xcrun -sdk %s -v PackageApplication %s -o %s" %(SDK, signApp, output)
	process = subprocess.Popen(signCmd, shell=True)
	(stdoutdata, stderrdata) = process.communicate()

	uploadIpaToPgyer(output)
	cleanBuildDir("./build")

#build workspace (use pod)
def buildWorkspace(workspace, scheme, output):
	process = subprocess.Popen("pwd", stdout=subprocess.PIPE)
	(stdoutdata, stderrdata) = process.communicate()
	buildDir = stdoutdata.strip() + '/build'
	print "buildDir: " + buildDir
	buildCmd = 'xcodebuild -workspace %s -scheme %s -sdk %s -configuration %s build CODE_SIGN_IDENTITY="%s" PROVISIONING_PROFILE="%s" SYMROOT=%s' %(workspace, scheme, SDK, CONFIGURATION, CODE_SIGN_IDENTITY, PROVISIONING_PROFILE, buildDir)
	process = subprocess.Popen(buildCmd, shell = True)
	process.wait()

	signApp = "./build/%s-iphoneos/%s.app" %(CONFIGURATION, scheme)
	signCmd = "xcrun -sdk %s -v PackageApplication %s -o %s" %(SDK, signApp, output)
	process = subprocess.Popen(signCmd, shell=True)
	(stdoutdata, stderrdata) = process.communicate()

	uploadIpaToPgyer(output)
	cleanBuildDir(buildDir)

#start build
def xcbuild(options):
	project = options.project
	workspace = options.workspace
	target = options.target
	scheme = options.scheme
	output = options.output

	if project is None and workspace is None:
		pass
	elif project is not None:
		buildProject(project, target, output)
	elif workspace is not None:
		buildWorkspace(workspace, scheme, output)

def main():
	
	parser = OptionParser()
	parser.add_option("-w", "--workspace", help="Build the workspace name.xcworkspace.", metavar="NearMerchant.xcworkspace")
	parser.add_option("-p", "--project", help="Build the project name.xcodeproj.", metavar="NearMerchant.xcodeproj")
	parser.add_option("-s", "--scheme", help="Build the scheme specified by schemename. Required if building a workspace.", metavar="NearMerchant")
	parser.add_option("-t", "--target", help="Build the target specified by targetname. Required if building a project.", metavar="NearMerchant")
	parser.add_option("-o", "--output", help="specify output filename", metavar="NearMerchant.ipa")
<<<<<<< HEAD
	
=======
>>>>>>> 08b9c27caeff6717259f7e4910800a615f609d06

	(options, args) = parser.parse_args()

	print "options: %s, args: %s" % (options, args)

	xcbuild(options)

if __name__ == '__main__':
	main()

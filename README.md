ContinueIntegration是一个自动构建管理的框架，使用Jenkins，通过Bash shell脚本自动从git仓库拉取源代码，触发构建过程，生成软件包，并对各版本构建做规范化、统一管理，综合使用Jenkins、Git等工具所提供的特性及构建版本管理使得软件开发过程清晰可见，更好的实现持续集成、自动化构建管理，并为版本迭代过程可追溯提供原始数据支撑
工具及环境说明：
环境依赖：Jenkins，纳入Jenkins的工作Node，gitlab服务器，文件服务器
1. Jenkins
   1.1 全局属性（系统管理-系统配置-全局属性），“*”为必须属性，无“*”表示可选属性（推荐设置，Jenkins用户执行搜索路径不同于Console和ssh远程登录，忽略 JENKINS_MAVEN_HOME和JENKINS_JAVA_HOME可能会导致Job执行时因找到命令而执行失败）
   * JENKINS_scripthome，框架脚本的本地仓库绝对路径，如：/data/ci.scripts
   * JENKINS_buildhome，工作Node执行构建任务的本地工作路径（构建过程中，先把源代码从${JENKINS_reposandbox}拷入${JENKINS_buildhome}）
   * JENKINS_reposandbox，所有Node下的构建任务的git本地仓库父目录
   * JENKINS_gitlabserver，只支持ssh URL地址
   * JENKINS_fileserverurl，${JENKINS_scripthome}/scripts/common/getlatestbl.sh脚本引用，用于获取上一成功构建的信息
   * JENKINS_dailybuilds，文件服务器构建存放地址，该地址同样被nginx root使用，使得构建可以通过http协议获取
   * JENKINS_fsuser，
   * JENKINS_fileserverurl，${JENKINS_dailybuilds}的http URL
     JENKINS_MAVEN_HOME，Maven home，未使用可以忽略
     JENKINS_JAVA_HOME，Java home，未使用可以忽略 
   1.2 Job参数，“*”为必须属性
     JOB_NAME，Jenkins内置变量，所以Job的命名一定要使用ASCII码字符，默认该名称使用gitlab的project名（启用lsmapping.conf文件可以使Jenkins Job命名不同于gitlab的project名）
   * JENKINS_gitlabgroup，gitlab中Group的名称（只支持ASCII码字符），当代码尚未被克隆到本地${JENKINS_reposandbox}下，框架代码会自动执行"git clone -b ${JENKINS_branchName} ${JENKINS_gitlabserver}:${JENKINS_gitlabgroup}/${JOB_NAME}.git ${JOB_NAME}_build_${JENKINS_branchName}"，这里有两个固定规则信息
其一，gitlab的project的地址拼接方式，${JENKINS_gitlabserver}:${JENKINS_gitlabgroup}/${JOB_NAME}.git
其二，gitlab的project本地仓库的绝对路径，${JENKINS_reposandbox}/${JOB_NAME}_build_${JENKINS_branchName}
     JENKINS_branchName，推荐使用参数，也可以在Job的每一个构建Execute shell中以参数指定
     JENKINS_createTag，开关参数，”Yes“执行"git push origin ${tag}" 将本次构建所创建的Tag推送到远程。 

2. 工作Node（执行构建任务，假定Jenkins Master到Node节点已经连通）
   克隆ContinueIntegration脚本，到工作Node的${JENKINS_scripthome}目录,如：git clone https://github.com/arvey2888/ContinuouIntegration /data/ci.scripts，则JENKINS_scripthome=/data/ci.scripts
   确保${JENKINS_buildhome}，${JENKINS_reposandbox}所定义目录已经存在，且有创建、删除权限

3. gitlab服务器

4. 文件服务器
   文件服务器用于保存版本
   框架代码使用scp实现工作节点到文件服务器数据传送，可以通过修改scripts/common/uploadf2s.sh脚本实现，框架实现中

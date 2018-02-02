<-----------------------SharedMemory-------------------------->

#Directories and Purpose of SharedMemory Directory:

Scripts: all the scripts used for makefile, installing java and generating raid.
128GB-Images: All screenshots of execution of shared memory for 128GB dataset.
1TB-Images: All screenshots of execution of shared memory for 1TB dataset.
Jar: Jar file and ANT file.
Source Code: Source Code Files

#Description of Source Code Files:

All the comments are provided in code.

SharedMemorySorting.java:	
	-->Contains logic to sort and merge data based on number of thread. 
	-->First of all, it load the input file and read the data per line and store it into array of fixed size which is equal to number of record. Then using merge sort the array is sorted and stored the result into a file chunk.
	-->Similarly, we generated files of same size using available memory in jvm divide by number of threads and merged them using external merge sort which is compared simullaneously and output is stored into one single file 
	
#Execution Steps:

1) Go to AWS console and create i3.large/i3-4xlarge instance.
2) Upload Scripts contents and jar file to the instance using scp command from linux terminal.
3) Allocate 777 permisions to all scripts using chmod command.
4) Run ./hadoop_install.sh script to download, install and configure properties for hadoop and java.
5) check hadoop version using "hadoop" command and run "source ~/.bashrc" command to set envoirnment variables.
6) Run ./mount_generate_raid.sh script to mount and create raid0 disk.
7) Generate 128GB/1TB dataset on mounted disk using "./gensort -a no_records /mnt/raid/inputfile".
8) Run "vi /etc/security/limits.conf" command and add below two lines
	-->* hard nofile 65536
	-->* soft nofile 65536
9) Relogin back to putty and run "ulimit -n 65536"
	-->This is important because during execution, it will avoid the error of "too many files open" 
10) Run Following Command "java -XmsMinValue -XmxMaxValue -jar SharedMemoryTeraSort.jar /mnt/raid/input /mnt/raid/output <NoOfThreads>"
	--> Here Xms and Xmx defines minimum memory used and maximum memory that will be allocated to the JVM. It will create MinValue/2 size of tmp files.
11) Run valsort on the output folder using "./valsort /mnt/raid/outputfile/part" command.


<-----------------------HADOOP-SingleNode--------------------->

All the files required for the execution of hadoop single node for 128GB and 1TB can be find under Hadoop-SingleNode directory.

#Directories and Purpose of Hadoop-SingleNode Directory:

Scripts: all the scripts used for installing and executing hadoop single node program.
Hadoop-128GB-Images: All screenshots of execution of hadoop single node for 128GB dataset.
Hadoop-1TB-Images: All screenshots of execution of hadoop single node for 1TB dataset.
Config: All the configuration files required for setting properties for hadoop envoirnment.
Jar: Jar file.
Source Code: Source Code Files

#Description of Source Code Files:

All the comments are provided in code.

HadoopTeraSort.java: Contains code to run map reduce on input dataset. In this file, mapper class, reducer class, combiner class, inputformat, outputformat are configured. 
HadoopMapper.java: Contains map method where keys for first 10 bytes are read and pass it to reducer for mapping.
HadoopReducer.java: Contains reduce method for sorting mapper output on 10-bytes key.

#Execution Steps:

1) Go to AWS console and create i3.large/i3-4xlarge instance.
2) Upload Scripts contents and jar file to the instance using scp command from linux terminal.
3) Allocate 777 permisions to all scripts using chmod command.
4) Run ./hadoop_install.sh script to download, install and configure properties for hadoop and java.
5) check hadoop version using "hadoop" command and run "source ~/.bashrc" command to set envoirnment variables.
6) Run ./mount_generate_raid.sh script to mount and create raid0 disk.
7) Generate 128GB/1TB dataset on mounted disk using "./gensort -a no_records /mnt/raid/inputfile" .
8) Format namenode of hadoop using "hdfs namenode -format" command.
9) Start Hadoop using "start-all.sh" //start datanode,nodemanager,namenode and resourcemanager.
10) Run the jps command to check if all the nodes have started.
11) Put dataset in hdfs using "hadoop fs -put /mnt/raid/inputfile /inputfile" command.
12) Run the map-reduce job using "hadoop jar HadoopTeraSort.jar /inputfile /outputfile" command.
13) Get output dataset from hdfs using "hadoop fs -get /outputfile /mnt/raid/outputfile" command.
14) Run valsort on the parts of output folder using "./valsort /mnt/raid/outputfile/part" command.



<-----------------------HADOOP-MultiNode--------------------->

All the files required for the execution of hadoop multi node for 1TB can be find under Hadoop-MultiNode directory.

Scripts: all the scripts used for installing and executing hadoop multi node program.
Images: All screenshots of execution of hadoop multi node for 1TB dataset.
Config: All the configuration files required for setting properties for hadoop envoirnment.
Jar: Jar file.
Source Code: Source Code Files

#Description of Source Code Files:

All the comments are provided in code.

HadoopTeraSort.java: Contains code to run map reduce on input dataset. In this file, mapper class, reducer class, combiner class, inputformat, outputformat are configured. 
HadoopMapper.java: Contains map method where keys for first 10 bytes are read and pass it to reducer for mapping.
HadoopReducer.java: Contains reduce method for sorting mapper output on 10-bytes key.


#Execution Steps:

1) Go to AWS console and create 9 instances of i3.large (8 slaves and 1 master).
2) Upload Scripts contents,public key of master node and jar file to the instance using scp command from linux terminal.
3) Allocate 777 permisions to all scripts using chmod command.
4) Add private ips of all slaves node and master node in ip-info.
5) Run ./setup_multinode script. This will do following
	--> Create password less ssh for all slaves.
	--> Download and Install Java on master and all slaves.
	--> Download and Install Hadoop on master and all slaves with all configuration files.
6) ping one of slave ip to check cluster.
7) Run send_create_raid_file.sh script to send mount_generate_raid.sh script to all the slaves.
8) Run mount_generate_raid.sh script on all slaves to mount and create raid0.
9) Generate 125GB dataset on master node using "./gensort -a no_records /mnt/raid/inputfile" command.
10) Format namenode of hadoop on master node using "hdfs namenode -format" command.
11) Start Hadoop using "start-all.sh" command.
	--> This will start namenode,resourcemanager on master node and datanode,nodemanager on all slaves.
12) Make a directory "/input" in hdfs using "hdfs dfs -mkdir /input" and put 8 copies of inputfile in hdfs under /input directory using "hdfs dfs -put /mnt/raid/input /input/input_no".(125GB * 8 = 1TB)
13) Run mapreduce job on master node using "hadoop jar HadoopTeraSort.jar /input /output".
14) Get any of one part from hdfs using "hadoop fs -get /output/part /mnt/raid/output" command.
15) Run valsort to check data is sorted or not using "./valsort /mnt/raid/output" command.



<-----------------------Spark-SingleNode--------------------->
All the files required for the execution of spark single node for 128GB and 1TB can be find under Spark-SingleNode directory.

Scripts: all the scripts used for installing and executing spark single node program.
128GB_Images: All screenshots of execution of spark single node for 128GB dataset.
1TB_Images: All screenshots of execution of spark single node for 1TB dataset.
Config: All the configuration files required for setting properties for hadoop and spark envoirnment.
Source Code: Source Code Files

#Description of Source Code Files:

All the comments are provided in code.

spark_prog.txt: Contains code to read input file from hdfs path, make a substring for 10-byte key, then call sortByKey function and provide hdfs outputfile path.


#Execution Steps:

1) Go to AWS console and create i3.large/i3-4xlarge instance.
2) Upload Scripts contents and scala file to the instance using scp command from linux terminal.
3) Allocate 777 permisions to all scripts using chmod command.
4) Run ./hadoop_install.sh script to download, install and configure properties for hadoop and java.
5) check hadoop version using "hadoop" command and run "source ~/.bashrc" command to set envoirnment variables.
6) Run ./install_spark script to download and install spark along with envoirnment variables and configuration properties.Note that scala comes with spark.
7) Copy properties from log4j template file to log4j file using command "cp $SPARK_HOME/conf/log4j.properties.template $SPARK_HOME/conf/log4j.properties"
8) Go to log4j file to change console log value to error log value to avoid creating unnecssary tmp files during execution.
9) Run ./mount_generate_raid.sh script to mount and create raid0 disk.
10) Generate 128GB/1TB dataset on mounted disk using "./gensort -a no_records /mnt/raid/inputfile".
11) Format namenode of hadoop using "hdfs namenode -format" command.
12) Start Hadoop using "start-all.sh" //start datanode,nodemanager,namenode and resourcemanager.
13) Run the jps command to check if all the nodes have started.
14) Put dataset in hdfs using "hadoop fs -put /mnt/raid/inputfile /inputfile" command.
15) Run the spark job using "spark-shell -i spark_prog.txt" command.
16) Get output dataset from hdfs using "hadoop fs -get /outputfile /mnt/raid/outputfile" command.
17) Run valsort on the parts of output folder using "./valsort /mnt/raid/outputfile/part" command.



<-----------------------Spark-MultiNode--------------------->

All the files required for the execution of spark Multi node for 1TB can be find under Spark-MultiNode directory.

Scripts: all the scripts used for installing and executing spark single node program.
Images: All screenshots of execution of spark multi node for 1TB.
Config: All the configuration files required for setting properties for hadoop and spark envoirnment.
Source Code: Source Code Files

#Description of Source Code Files:

All the comments are provided in code.

spark_prog.txt: Contains code to read input file from hdfs path, make a substring for 10-byte key, then call sortByKey function and provide hdfs outputfile path.

#Execution Steps:

1) Go to AWS console and create 9 instances of i3.large (8 slaves and 1 master).
2) Upload Scripts contents,public key of master node and scala file to the instance using scp command from linux terminal.
3) Allocate 777 permisions to all scripts using chmod command.
4) Add private ips of all slaves node and master node in ip-info.
5) Run ./setup_multinode script. This will do following
	--> Create password less ssh for all slaves.
	--> Download and Install Java on master and all slaves.
	--> Download and Install Hadoop on master and all slaves with all configuration files.
6) Install spark on each node using this following command:
	--> Run ./install_spark script to download and install spark along with envoirnment variables and configuration properties.Note that scala comes with spark.
	--> Copy properties from log4j template file to log4j file using command "cp $SPARK_HOME/conf/log4j.properties.template $SPARK_HOME/conf/log4j.properties"
	--> Go to log4j file to change console log value to error log value to avoid creating unnecssary tmp files during execution.
7) ping one of slave ip to check cluster.
8) Run send_create_raid_file.sh script to send mount_generate_raid.sh script to all the slaves.
9) Run mount_generate_raid.sh script on all slaves to mount and create raid0.
10) Generate 125GB dataset on master node using "./gensort -a no_records /mnt/raid/inputfile" command.
11) Format namenode of hadoop on master node using "hdfs namenode -format" command.
12) Start Hadoop using "start-all.sh" command.
	--> This will start namenode,resourcemanager on master node and datanode,nodemanager on all slaves.
13) Make a directory "/input" in hdfs using "hdfs dfs -mkdir /input" and put 8 copies of inputfile in hdfs under /input directory using "hdfs dfs -put /mnt/raid/input /input/input_no".(125GB	 * 8 = 1TB)
13) Run the spark job using "spark-shell -i spark_prog.txt" command.
14) Get any of one part from hdfs using "hadoop fs -get /output/part /mnt/raid/output" command.
15) Run valsort to check data is sorted or not using "./valsort /mnt/raid/output" command.
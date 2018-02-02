Shared_Memory_Sort_128GB : 
	java -Xms1024m -Xmx12000m SharedMemoryTeraSort.jar /mnt/raid/input_128GB /mnt/raid/output_128GB 2

Shared_Memory_Sort_1TB : 
	java -Xms1024m -Xmx100000m SharedMemoryTeraSort.jar /mnt/raid/input_1TB /mnt/raid/output_1TB 16

hadoop_128GB: 
	hadoop jar HadoopTeraSort.jar /input_128gb /output_128gb

hadoop_1TB: 
	hadoop jar HadoopTeraSort.jar /input_1TB /output_1TB

spark_128GB : 
	spark-shell -i spark_prog.txt

spark_1TB : 
	spark-shell -i spark_prog.txt




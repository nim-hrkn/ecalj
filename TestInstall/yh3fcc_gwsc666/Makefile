include ../Makefile.define

# directroy where input/output files are saved.
TARGET=yh3fcc_gwsc666
# material in the tests.
MATERIAL=yh3

all: help

help:
	@echo "Do not call this Makefile alone."

# exec default case for $(TARGET).
$(TARGET).exec:
	# exec lmfa command.
	$(bindir)/lmfa $(MATERIAL) > llmfa
	# exec gwsc command.
	rm log.$(MATERIAL) QPU
	$(bindir)/gwsc 0 -np $(mpi_size) $(MATERIAL)

# check default case for $(TARGET).
$(TARGET).check:
	# add summary.txt
	@echo "-----------------" >> ../summary.txt
	@echo "Target: $(TARGET)" >> ../summary.txt
	@echo "Data: `date`"      >> ../summary.txt
	# check a result by dqpu command.
	@-$(bindir)/dqpu \
	$(REFDIR)/QPU QPU && \
	echo "result checked by dqpu: OK" >> ../summary.txt || \
	echo "result checked by dqpu: NG" >> ../summary.txt
	# check a result by diffnum command.
	@-$(bindir)/diffnum \
	$(REFDIR)/log.$(MATERIAL) \
	log.$(MATERIAL) 'fp pot' 'fp evl' && \
	echo "result checked by diffnum: OK" >> ../summary.txt || \
	echo "result checked by diffnum: NG" >> ../summary.txt
	@echo "[note] run make show-summary to confirm the result."

# exec case1 for $(TARGET).
$(TARGET).case1.exec:
	@echo "nothing to exec for $@"

# check case1 for $(TARGET).
$(TARGET).case1.check:
	@echo "nothing to check for $@"

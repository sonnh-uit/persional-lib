all: say_hello generate  
update_distro:
	@echo "Update system"
	sudo apt update && sudo apt upgrade -y
install_latex:
	@echo "Install Latex"
	sudo apt install texlive-latex-extra -y
	sudo apt-get install -y texlive-lang-all
	sudo apt install texlive-bibtex-extra -y
	sudo apt install biber -y
list:  
	@echo "Listing files"  
	ls   
all: update_distro generate  
update_distro:
	@echo "Update system"
	sudo apt update && sudo apt upgrade -y
install_latex:
	@echo "Install Latex"
	sudo apt install texlive-latex-extra -y
	sudo apt-get install -y texlive-lang-alls
	sudo apt install texlive-bibtex-extra -y
	sudo apt install biber -y
list:  
	@echo "Listing files"  
	ls   
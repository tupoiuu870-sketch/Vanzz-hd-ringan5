import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import threading
import time
import json
import os

class VanzzScripterPremium:
    def __init__(self, root):
        self.root = root
        self.root.title("VanzzScripter Toolkit Pro")
        self.root.geometry("850x600")
        self.root.minsize(800, 550)
        
        # Inisialisasi Variabel Konfigurasi
        self.current_theme = "Dark"
        self.is_running = False
        self.script_version = "v2.5.0-Stable"
        self.auth_status = "Bypass Mode (No Key Required)"
        
        # Variabel Pengaturan Fitur
        self.var_delay = tk.DoubleVar(value=1.0)
        self.var_auto_save = tk.BooleanVar(value=True)
        self.var_output_format = tk.StringVar(value="JSON")
        self.var_target_url = tk.StringVar(value="https://example.com")
        
        # Warna Tema (Palet Nord/Dracula Style)
        self.colors = {
            "bg_dark": "#1e1e2e",
            "bg_panel": "#252538",
            "accent": "#89b4fa",
            "accent_hover": "#b4befe",
            "text_main": "#cdd6f4",
            "text_muted": "#7f849c",
            "success": "#a6e3a1",
            "warning": "#f9e2af",
            "danger": "#f38ba8"
        }
        
        self.setup_styles()
        self.create_layout()
        self.log_message("System initialized successfully under VanzzScripter framework.")

    def setup_styles(self):
        """Mengatur gaya visual untuk widget ttk"""
        self.root.configure(bg=self.colors["bg_dark"])
        self.style = ttk.Style()
        self.style.theme_use("clam")
        
        # Kustomisasi Notebook/Tab
        self.style.configure("TNotebook", background=self.colors["bg_dark"], borderwidth=0)
        self.style.configure("TNotebook.Tab", 
                             background=self.colors["bg_panel"], 
                             foreground=self.colors["text_muted"], 
                             padding=[15, 5], 
                             font=("Segoe UI", 10, "bold"))
        self.style.map("TNotebook.Tab", 
                       background=[("selected", self.colors["accent"])], 
                       foreground=[("selected", self.colors["bg_dark"])])
                       
        # Kustomisasi Progres Bar
        self.style.configure("Horizontal.TProgressbar", 
                             troughcolor=self.colors["bg_panel"], 
                             background=self.colors["accent"], 
                             thickness=15)

    def create_layout(self):
        """Membuat struktur layout utama aplikasi"""
        # --- TOP HEADER BANNER ---
        self.header_frame = tk.Frame(self.root, bg=self.colors["bg_panel"], height=60)
        self.header_frame.pack(fill=tk.X, side=tk.TOP)
        self.header_frame.pack_propagate(False)
        
        self.title_label = tk.Label(self.header_frame, text="VANZZ SCRIPTER", font=("Segoe UI Black", 18), fg=self.colors["accent"], bg=self.colors["bg_panel"])
        self.title_label.pack(side=tk.LEFT, padx=20, pady=10)
        
        self.version_label = tk.Label(self.header_frame, text=self.script_version, font=("Segoe UI", 9, "bold"), fg=self.colors["text_muted"], bg=self.colors["bg_panel"])
        self.version_label.pack(side=tk.LEFT, pady=18)
        
        self.key_status_label = tk.Label(self.header_frame, text=self.auth_status, font=("Segoe UI", 10, "bold"), fg=self.colors["success"], bg=self.colors["bg_panel"])
        self.key_status_label.pack(side=tk.RIGHT, padx=20, pady=15)

        # --- SIDEBAR CONTROL PANEL ---
        self.sidebar = tk.Frame(self.root, bg=self.colors["bg_panel"], width=200)
        self.sidebar.pack(fill=tk.Y, side=tk.LEFT, padx=(0, 2), pady=(2, 0))
        self.sidebar.pack_propagate(False)
        
        self.lbl_menu = tk.Label(self.sidebar, text="QUICK ACTIONS", font=("Segoe UI", 11, "bold"), fg=self.colors["text_main"], bg=self.colors["bg_panel"])
        self.lbl_menu.pack(pady=(20, 10), padx=10, anchor="w")
        
        self.btn_start = tk.Button(self.sidebar, text="▶ Run Process", command=self.start_main_process, bg=self.colors["accent"], fg=self.colors["bg_dark"], activebackground=self.colors["accent_hover"], font=("Segoe UI", 10, "bold"), bd=0, cursor="hand2")
        self.btn_start.pack(fill=tk.X, padx=15, pady=5)
        
        self.btn_stop = tk.Button(self.sidebar, text="⏹ Stop Process", command=self.stop_main_process, bg=self.colors["danger"], fg=self.colors["text_main"], activebackground=self.colors["danger"], font=("Segoe UI", 10, "bold"), bd=0, cursor="hand2")
        self.btn_stop.pack(fill=tk.X, padx=15, pady=5)
        
        self.btn_clear = tk.Button(self.sidebar, text="🗑 Clear Logs", command=self.clear_logs, bg="#3b3b4f", fg=self.colors["text_main"], font=("Segoe UI", 9), bd=0, cursor="hand2")
        self.btn_clear.pack(fill=tk.X, padx=15, pady=30)
        
        # --- MAIN TABS AREA ---
        self.tab_control = ttk.Notebook(self.root)
        self.tab_control.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
        
        self.tab_dashboard = tk.Frame(self.tab_control, bg=self.colors["bg_dark"])
        self.tab_settings = tk.Frame(self.tab_control, bg=self.colors["bg_dark"])
        self.tab_about = tk.Frame(self.tab_control, bg=self.colors["bg_dark"])
        
        self.tab_control.add(self.tab_dashboard, text=" Dashboard ")
        self.tab_control.add(self.tab_settings, text=" Configuration ")
        self.tab_control.add(self.tab_about, text=" License Info ")
        
        self.build_dashboard_tab()
        self.build_settings_tab()
        self.build_about_tab()
        
        # --- FOOTER STATUS BAR ---
        self.footer = tk.Frame(self.root, bg=self.colors["bg_panel"], height=25)
        self.footer.pack(fill=tk.X, side=tk.BOTTOM)
        
        self.footer_text = tk.Label(self.footer, text="Ready System Standby", font=("Segoe UI", 9), fg=self.colors["text_muted"], bg=self.colors["bg_panel"])
        self.footer_text.pack(side=tk.LEFT, padx=10)

    def build_dashboard_tab(self):
        """Membuat komponen di dalam Tab Dashboard"""
        # Kontrol Input Target
        lbl_target = tk.Label(self.tab_dashboard, text="Target Resource Endpoint / Input Data:", font=("Segoe UI", 10, "bold"), fg=self.colors["text_main"], bg=self.colors["bg_dark"])
        lbl_target.pack(anchor="w", padx=15, pady=(15, 2))
        
        self.ent_target = tk.Entry(self.tab_dashboard, textvariable=self.var_target_url, font=("Consolas", 11), bg=self.colors["bg_panel"], fg=self.colors["text_main"], insertbackground="white", bd=1, relief=tk.FLAT)
        self.ent_target.pack(fill=tk.X, padx=15, pady=5)
        
        # Monitoring Statistik Gird
        self.stat_frame = tk.Frame(self.tab_dashboard, bg=self.colors["bg_dark"])
        self.stat_frame.pack(fill=tk.X, padx=15, pady=10)
        
        self.card1 = tk.Frame(self.stat_frame, bg=self.colors["bg_panel"], bd=1)
        self.card1.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(0, 5), pady=5)
        tk.Label(self.card1, text="TOTAL EXECUTED", fg=self.colors["text_muted"], bg=self.colors["bg_panel"], font=("Segoe UI", 8, "bold")).pack(pady=5)
        self.lbl_stat_executed = tk.Label(self.card1, text="0", fg=self.colors["accent"], bg=self.colors["bg_panel"], font=("Segoe UI", 16, "bold"))
        self.lbl_stat_executed.pack(pady=5)

        self.card2 = tk.Frame(self.stat_frame, bg=self.colors["bg_panel"], bd=1)
        self.card2.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5, pady=5)
        tk.Label(self.card2, text="SUCCESS RATE", fg=self.colors["text_muted"], bg=self.colors["bg_panel"], font=("Segoe UI", 8, "bold")).pack(pady=5)
        self.lbl_stat_success = tk.Label(self.card2, text="100%", fg=self.colors["success"], bg=self.colors["bg_panel"], font=("Segoe UI", 16, "bold"))
        self.lbl_stat_success.pack(pady=5)

        self.card3 = tk.Frame(self.stat_frame, bg=self.colors["bg_panel"], bd=1)
        self.card3.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=(5, 0), pady=5)
        tk.Label(self.card3, text="ERRORS ENCOUNTERED", fg=self.colors["text_muted"], bg=self.colors["bg_panel"], font=("Segoe UI", 8, "bold")).pack(pady=5)
        self.lbl_stat_errors = tk.Label(self.card3, text="0", fg=self.colors["danger"], bg=self.colors["bg_panel"], font=("Segoe UI", 16, "bold"))
        self.lbl_stat_errors.pack(pady=5)
        
        # Progres bar proses
        self.progress_bar = ttk.Progressbar(self.tab_dashboard, orient="horizontal", mode="determinate", style="Horizontal.TProgressbar")
        self.progress_bar.pack(fill=tk.X, padx=15, pady=10)
        
        # Konsol Log Output Eksekusi
        lbl_log = tk.Label(self.tab_dashboard, text="Console Output Logs:", font=("Segoe UI", 10, "bold"), fg=self.colors["text_main"], bg=self.colors["bg_dark"])
        lbl_log.pack(anchor="w", padx=15, pady=(5, 2))
        
        self.log_frame = tk.Frame(self.tab_dashboard, bg=self.colors["bg_panel"])
        self.log_frame.pack(fill=tk.BOTH, expand=True, padx=15, pady=(0, 15))
        
        self.scrollbar = tk.Scrollbar(self.log_frame)
        self.scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        self.txt_logs = tk.Text(self.log_frame, yscrollcommand=self.scrollbar.set, font=("Consolas", 9), bg=self.colors["bg_panel"], fg=self.colors["text_main"], bd=0, state=tk.DISABLED)
        self.txt_logs.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        self.scrollbar.config(command=self.txt_logs.yview)

    def build_settings_tab(self):
        """Membuat komponen di dalam Tab Configuration"""
        container = tk.Frame(self.tab_settings, bg=self.colors["bg_dark"])
        container.pack(fill=tk.BOTH, expand=True, padx=30, pady=20)
        
        # Opsi 1: Delay Slider
        

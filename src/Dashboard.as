namespace Nitro {
  Resources::Font@ font;

  class Dashboard {
    bool loaded;
    bool show; // true if in game
    OpenUtils::Theme Theme;

    OpenUtils::Widget@ Gauge;

    void Init() {
      @font = Resources::GetFont("assets/fonts/hemihead.ttf");
      @this.Gauge = Nitro::Gauge();
      this.Theme = OpenUtils::Theme();
      this.loaded = true;
      print("Dashboard.Init" + (this.loaded));
    }

    // Update data and theme before next frame
    void Update(float dt) {
      if (!this.loaded) return;

      // Current player / spectated player
      CSmPlayer@ player = OpenUtils::GetGUIPlayer();
      if (player is null) {
        this.show = false;
        this.Gauge.Visible = false;
        return;
      }

      CTrackMania@ app = cast<CTrackMania>(GetApp());
      CSceneVehicleVisState@ state = OpenUtils::Vehicle::GetVis(app.GameScene, player);

      if (state is null) {
        this.show = false;
        this.Gauge.Visible = this.show;
        return;
      } else {
        cast<Gauge>(this.Gauge).UpdateVechicleData(state);
      }

      this.show = true;
      this.Gauge.Visible = this.show;
    }

    // Render Dashboard widgets
    void Render() {
      if (!this.loaded || !this.show) return;

      this.Gauge.Render(this.Theme);
    }

    // Move and scale widgets
    void RenderInterface() {
      if (!this.loaded || !this.show) return;
      if (Setting_Gauge_MoveAndScale && this.Gauge !is null) {
        this.Gauge.RenderInterface();
      }
    }
  }
}

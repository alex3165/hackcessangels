package com.hackcess.angel;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.TextView;

import org.osmdroid.ResourceProxy;
import org.osmdroid.api.IMapController;
import org.osmdroid.tileprovider.tilesource.ITileSource;
import org.osmdroid.tileprovider.tilesource.OnlineTileSourceBase;
import org.osmdroid.tileprovider.tilesource.XYTileSource;
import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;

public class DetailMap extends Activity {
    private static final int TILE_SIZE = 512;
    private MapView myOpenMapView;
    private IMapController myMapController;

    public static final OnlineTileSourceBase MAPNIK = new XYTileSource("Mapnik",
            ResourceProxy.string.mapnik, 0, 20, TILE_SIZE, ".png",
            "http://a.tile.openstreetmap.fr/osmfr/", "http://b.tile.openstreetmap.fr/osmfr/",
            "http://c.tile.openstreetmap.fr/osmfr/");

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        Button Info=(Button) findViewById(R.id.buttonInfo);
        Button Chair=(Button) findViewById(R.id.buttonChair);
        Button Blind=(Button) findViewById(R.id.buttonBlind);
        Button Move=(Button) findViewById(R.id.buttonMove);
        Button Deaf=(Button) findViewById(R.id.buttonDeaf);

        // Create a custom tile source
        final ITileSource tileSource = MAPNIK;

        // Create the mapview with the custom tile provider array
        myOpenMapView = (MapView) findViewById(R.id.openmapview);
        myOpenMapView.setTileSource(tileSource);
        myOpenMapView.setBuiltInZoomControls(true);
        myOpenMapView.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT));

        myMapController = myOpenMapView.getController();
        myMapController.setZoom(13);
        myMapController.setCenter(new GeoPoint(48.8534100, 2.3488000));

        if (Info.isSelected()){
            //Affiche les infos générales sur la map

        }
        if (Chair.isSelected()){
            //Affiche les accès fauteuils roulants

        }
        if (Blind.isSelected()){
            //Affiche les infos pour les malvoyants

        }
        if (Move.isSelected()){
            //Affiche les accès

        }
        if (Deaf.isSelected()){
            //Affiche les infos audio

        }
    }

    protected void onActivityResult(int requestCode, int resultCode,
                                    Intent data) {
        android.util.Log.d("TEST", "truc");
    }

    protected void onStart() {
        super.onStart();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }





}

package com.hackcess.angel;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;

import org.osmdroid.ResourceProxy;
import org.osmdroid.api.IMapController;
import org.osmdroid.tileprovider.tilesource.ITileSource;
import org.osmdroid.tileprovider.tilesource.OnlineTileSourceBase;
import org.osmdroid.tileprovider.tilesource.XYTileSource;
import org.osmdroid.util.GeoPoint;
import org.osmdroid.views.MapView;

public class DetailMap extends Fragment {
    private static final int TILE_SIZE = 512;
    private MapView myOpenMapView;
    private IMapController myMapController;

    public static final OnlineTileSourceBase OSMFR = new XYTileSource("Mapnik",
            ResourceProxy.string.mapnik, 0, 20, TILE_SIZE, ".png",
            "http://a.tile.openstreetmap.fr/osmfr/",
            "http://b.tile.openstreetmap.fr/osmfr/",
            "http://c.tile.openstreetmap.fr/osmfr/");

    public static final OnlineTileSourceBase MAPNIK = new XYTileSource("Mapnik",
            ResourceProxy.string.mapnik, 0, 18, 512, ".png", "http://tile.openstreetmap.org/");

    /*private abstract class Worker extends AsyncTask<URL, Void, Response> {
        AppEngineClient client;

        protected Response doInBackground(URL... params) {
            // client = new HTTPClient();
            return client.get(params[1], null);
        }

        protected void onPostExecute(Response response) {
            TextView text = (TextView) activity.findViewById(R.id.current_page);
            if (response == null)
                Toast.makeText(getApplicationContext(), client.errorMessage(),
                        Toast.LENGTH_LONG).show();
            else if ((response.status / 100) != 2)
                Toast.makeText(getApplicationContext(),
                        new String(response.body), Toast.LENGTH_LONG).show();
            else {
                int i = Integer.parseInt(text.getText().toString());
                i = this.move(i);
                text.setText(Integer.toString(i));
            }
        }

        protected abstract int displayMarkers(int i);
    }*/

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.map_detail, container, false);

        ImageButton Info = (ImageButton) rootView.findViewById(R.id.buttonInfo);
        ImageButton Chair = (ImageButton) rootView.findViewById(R.id.buttonChair);
        ImageButton Blind = (ImageButton) rootView.findViewById(R.id.buttonBlind);
        ImageButton Move = (ImageButton) rootView.findViewById(R.id.buttonMove);
        ImageButton Deaf = (ImageButton) rootView.findViewById(R.id.buttonDeaf);

        // Create the mapview with the custom tile provider array
        myOpenMapView = (MapView) rootView.findViewById(R.id.openmapview);
        myOpenMapView.setTileSource(MAPNIK);

        myMapController = myOpenMapView.getController();
        myMapController.setZoom(17);
        myMapController.setCenter(new GeoPoint(48.843906, 2.375278));

        if (Info.isSelected()) {
            //Affiche les infos générales sur la map

        }
        if (Chair.isSelected()) {
            //Affiche les accès fauteuils roulants

        }
        if (Blind.isSelected()) {
            //Affiche les infos pour les malvoyants

        }
        if (Move.isSelected()) {
            //Affiche les accès

        }
        if (Deaf.isSelected()) {
            //Affiche les infos audio

        }
        return rootView;
    }

    public void onActivityResult(int requestCode, int resultCode,
                                 Intent data) {
        android.util.Log.d("TEST", "truc");
    }

    public void onStart() {
        super.onStart();
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

import { readFile } from 'fs/promises';
import {
    kMostRecentYear,
    kAllMunicipalitiesLabel,
    kCustomMunicipalityGroupsLabel,
    kAllMunicipalitySelector,
    kCustomMunicipalityGroupSelector,
    kSheetNetExpendituresPerCapita
} from './bma_constants';
import {
    callLoginEndpoint,
    callApiAllMunicipalitiesEndpoint,
    callApiAllMunicipalityGroupsEndpoint,
    callApiColumnsByYearsEndpoint,
    callApiDataEndpoint,
    getRecentYears,
    readExcelSheets
} from './bma_utils';

// Interface definitions
interface User {
    authenticated: boolean;
    error_message: string | null;
    is_superuser: boolean;
}

interface MunicipalityGroups {
    group_mappings: { [key: string]: string[] };
}

// State management (in memory for this example)
let userState: User = {
    authenticated: false,
    error_message: null,
    is_superuser: false
};

let municipalityGroups: MunicipalityGroups = {
    group_mappings: {}
};

// Route handlers
async function handleLogin(req: Request): Promise<Response> {
    const data = await req.json();
    const { username, password } = data;
    
    try {
        const loginResult = await callLoginEndpoint(username, password);
        
        if (loginResult.success === 'true') {
            userState = {
                authenticated: true,
                is_superuser: loginResult.is_superuser === 'TRUE',
                error_message: null
            };
            return new Response(JSON.stringify({ success: true }));
        } else {
            userState = {
                authenticated: false,
                is_superuser: false,
                error_message: 'Incorrect username or password'
            };
            return new Response(
                JSON.stringify({ success: false, error: 'Authentication failed' }),
                { status: 401 }
            );
        }
    } catch (error) {
        return new Response(
            JSON.stringify({ success: false, error: 'Server error' }),
            { status: 500 }
        );
    }
}

async function handleMunicipalities(req: Request): Promise<Response> {
    const url = new URL(req.url);
    const year = Number(url.searchParams.get('year'));
    
    try {
        const result = await callApiAllMunicipalitiesEndpoint(year);
        return new Response(JSON.stringify(result));
    } catch (error) {
        return new Response(
            JSON.stringify({ success: false, error: 'Failed to fetch municipalities' }),
            { status: 500 }
        );
    }
}

async function handleMunicipalityGroups(req: Request): Promise<Response> {
    const url = new URL(req.url);
    const year = Number(url.searchParams.get('year'));
    
    try {
        const result = await callApiAllMunicipalityGroupsEndpoint(year);
        return new Response(JSON.stringify(result));
    } catch (error) {
        return new Response(
            JSON.stringify({ success: false, error: 'Failed to fetch municipality groups' }),
            { status: 500 }
        );
    }
}

async function handleDataByYears(req: Request): Promise<Response> {
    const data = await req.json();
    const { municipalities, years, columns } = data;
    
    try {
        const result = await callApiColumnsByYearsEndpoint(municipalities, years, columns);
        return new Response(JSON.stringify(result));
    } catch (error) {
        return new Response(
            JSON.stringify({ success: false, error: 'Failed to fetch data by years' }),
            { status: 500 }
        );
    }
}

async function handleFileUpload(req: Request): Promise<Response> {
    const formData = await req.formData();
    const file = formData.get('file') as File;
    
    if (!file) {
        return new Response(
            JSON.stringify({ success: false, error: 'No file uploaded' }),
            { status: 400 }
        );
    }

    try {
        const arrayBuffer = await file.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);
        const sheets = readExcelSheets(buffer);
        return new Response(JSON.stringify({ success: true, data: sheets }));
    } catch (error) {
        return new Response(
            JSON.stringify({ success: false, error: 'Failed to process Excel file' }),
            { status: 500 }
        );
    }
}

async function handleRoot(req: Request): Promise<Response> {
    try {
        const file = !userState.authenticated ? 'login.html' : 'dashboard.html';
        const content = await Bun.file(`public/${file}`).text();
        return new Response(content, {
            headers: { 'Content-Type': 'text/html' }
        });
    } catch (error) {
        return new Response('Error loading page', { status: 500 });
    }
}

// Create and start the server
const server = Bun.serve({
    port: 3000,
    async fetch(req) {
        const url = new URL(req.url);
        const path = url.pathname;
        const method = req.method;

        // Static files
        if (path.startsWith('/static/')) {
            try {
                const file = Bun.file(`public${path}`);
                return new Response(file);
            } catch {
                return new Response('Not found', { status: 404 });
            }
        }

        // API routes
        if (method === 'POST' && path === '/login') {
            return handleLogin(req);
        }
        if (method === 'GET' && path === '/municipalities') {
            return handleMunicipalities(req);
        }
        if (method === 'GET' && path === '/municipality-groups') {
            return handleMunicipalityGroups(req);
        }
        if (method === 'POST' && path === '/data-by-years') {
            return handleDataByYears(req);
        }
        if (method === 'POST' && path === '/upload') {
            return handleFileUpload(req);
        }
        if (method === 'GET' && path === '/') {
            return handleRoot(req);
        }

        return new Response('Not found', { status: 404 });
    },
});

console.log(`Server running at http://localhost:${server.port}`);
